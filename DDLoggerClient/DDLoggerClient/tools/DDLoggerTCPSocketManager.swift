//
//  DDLoggerClientTCPSocketManager.swift
//  DDLoggerClient
//
//  Created by Damon on 2022/8/2.
//  Copyright © 2022 Damon. All rights reserved.
//

import Foundation
import CocoaAsyncSocket

class DDLoggerClientTCPSocketManager: NSObject {
    public static let shared = DDLoggerClientTCPSocketManager()
    var socketDidReceiveHandler: SocketDidReceiveHandler?
    var socketDidConnectHandler: SocketDidConnectHandler?
    private var timer: Timer?
    private(set) var socketHost: String = "" //UDP的端口
    private(set) var socketPort: UInt16 = 888 //UDP的端口
    private var acceptSocketList: [GCDAsyncSocket] = []
    private var connectSocketList: [GCDAsyncSocket] = []
}

extension DDLoggerClientTCPSocketManager {
    func start(hostName:String, port: UInt16) {
        self.socketHost = hostName
        self.socketPort = port
        let queue = DispatchQueue.init(label: "DDLoggerClient_socket")
        let socket = GCDAsyncSocket(delegate: self, delegateQueue: queue, socketQueue: queue)
        socket.isIPv4PreferredOverIPv6 = false
        do {
            try socket.connect(toHost: hostName, onPort: port, withTimeout: 20)
        } catch {
            print("connect error", error)
        }
        connectSocketList.append(socket)
        //心跳包
        self.sendHeartBeat()
    }

    func sendHeartBeat() {
        print("heart beat")
        timer?.invalidate()
        //发送心跳包
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { [weak self] _ in
            guard let self = self, let data = "h".data(using: .utf8) else {
                return
            }
            for socket in self.connectSocketList {
                socket.write(data, withTimeout: 20, tag: 0)
                socket.readData(withTimeout: -1, tag: 0)
            }
            if self.connectSocketList.isEmpty {
                self.timer?.invalidate()
                self.timer = nil
            }
        }
    }

}

extension DDLoggerClientTCPSocketManager: GCDAsyncSocketDelegate {
    func socket(_ sock: GCDAsyncSocket, didAcceptNewSocket newSocket: GCDAsyncSocket) {
        print("didAcceptNewSocket")
        if !acceptSocketList.contains(newSocket) {
            newSocket.delegate = self
            acceptSocketList.append(newSocket)
        }
        newSocket.readData(withTimeout: -1, tag: 0)
    }
    
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("didConnectToHost", host, port)
        if let socketDidConnectHandler = socketDidConnectHandler {
            socketDidConnectHandler(host, port)
        }
        //首次连接发送初始化
        guard let authData = "DDLoggerClient_tcp_auth".data(using: .utf8) else { return }
        sock.write(authData, withTimeout: 20, tag: 0)
        sock.readData(withTimeout: -1, tag: 0)
    }

    func socketDidDisconnect(_ sock: GCDAsyncSocket, withError err: Error?) {
        print("socketDidDisconnect")
        if let index = self.connectSocketList.firstIndex(of: sock) {
            self.connectSocketList.remove(at: index)
        }
    }

    func socket(_ sock: GCDAsyncSocket, didWriteDataWithTag tag: Int) {
//        print("didWriteDataWithTag")
    }

    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
//        print("didRead")
        //接受到需要log传输的消息，记录
        guard let receiveMsg = String(data: data, encoding: .utf8), let handler = self.socketDidReceiveHandler else {
            return
        }
        var msgList = receiveMsg.split(separator: "|")
        guard msgList.count >= 4, let itemType = Int(msgList.first!)  else {
            return
        }
        let item = DDLoggerClientItem()
        
        item.mLogItemType = ZXKitLogType(rawValue: itemType)
        item.mLogDebugContent = String(msgList[1])
        item.mCreateDate = Date(timeIntervalSince1970: TimeInterval(msgList[2]) ?? 0)
        msgList.removeFirst(3)
        item.updateLogContent(type: item.mLogItemType, content: msgList.joined(separator: "|"))
        handler(self.socketHost, sock.connectedPort, item)

        sock.readData(withTimeout: -1, tag: tag)
    }
}
