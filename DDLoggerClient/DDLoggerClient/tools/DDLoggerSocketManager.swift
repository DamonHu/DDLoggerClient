//
//  DDLoggerSocketManager.swift
//  DDLoggerClient
//
//  Created by Damon on 2025/3/20.
//
import Foundation
import Network

typealias BonjourDidConnectHandler = (_ name: String) -> ()
typealias SocketDidReceiveHandler = (_ name: String, _ item: DDLoggerClientItem) -> ()


struct ConnectionItem {
    var name: String
    var task: URLSessionWebSocketTask
}

class DDLoggerSocketManager: NSObject {
    static let shared = DDLoggerSocketManager()
    var socketDidReceiveHandler: SocketDidReceiveHandler?
    var bonjourDidConnectHandler: BonjourDidConnectHandler?
    
    private var webSocketTaskList: [ConnectionItem] = []
    let session = URLSession(configuration: .default)
    
    private var netServiceBrowser: NetServiceBrowser?
    private var netService: NetService?
    
}

extension DDLoggerSocketManager {
    func start() {
        let parameters = NWParameters.tcp
        parameters.includePeerToPeer = true
        //搜索服务
        netServiceBrowser = NetServiceBrowser()
        netServiceBrowser?.delegate = self
        netServiceBrowser?.searchForServices(ofType: "\(DDLoggerClient.socketType)._tcp.", inDomain: "local.")
    }
    
    private func receiveMessage(task: ConnectionItem) {
        task.task.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received text: \(text)")
                case .data(let data):
                    if let text = String(data: data, encoding: .utf8) {
                        print("Received data: \(text)")
                        if let logMessage = String(data: data, encoding: .utf8) {
                            print("Received message: \(logMessage)")
                            var msgList = logMessage.split(separator: "#")
                            print(msgList)
                            guard msgList.count >= 4, let itemType = Int(msgList.first!)  else {
                                return
                            }
                            let item = DDLoggerClientItem()
                            item.mLogItemType = DDLogType(rawValue: itemType)
                            item.mLogDebugContent = String(msgList[1])
                            item.mCreateDate = Date(timeIntervalSince1970: TimeInterval(msgList[2]) ?? 0)
                            msgList.removeFirst(3)
                            item.updateLogContent(type: item.mLogItemType, content: msgList.joined(separator: "|"))
                            if let socketDidReceiveHandler = self.socketDidReceiveHandler {
                                socketDidReceiveHandler("\(task.name)", item)
                            }
                        }
                    }
                @unknown default:
                    break
                }
                // 继续接收下一条消息
                self.receiveMessage(task: task)
            case .failure(let error):
                print("Receive error: \(error)")
            }
        }
    }
    
    // 发送日志
    func sendLogMessage(_ message: String, task: URLSessionWebSocketTask) {
        // 发送日志消息给已连接的客户端
        guard let logMessage = message.data(using: .utf8) else { return }
        
        task.send(URLSessionWebSocketTask.Message.data(logMessage)) { error in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Log message sent successfully: \(message)")
            }
        }
    }
    
    func sendHeartBeat(task: URLSessionWebSocketTask) {
        print("heart beat")
        //发送心跳包
        let heartTimer = Timer(timeInterval: 5, repeats: true, block: { [weak self] _ in
            guard let self = self else {
                return
            }
            self.sendLogMessage("heart beat", task: task)
        })
        RunLoop.main.add(heartTimer, forMode: .common)
    }
    
    // 获取从 netService 解析到的 IP 地址
    private func getIPAddress(from data: Data) -> String? {
//        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
//            data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
//                let sockaddr = pointer.bindMemory(to: sockaddr.self).baseAddress!
//                if getnameinfo(sockaddr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
//                    print("✅ 解析出的 IP 地址: \(String(cString: hostname))")
//                } else {
//                    print("❌ 无法解析 IP 地址")
//                }
//            }
//            
//            // 获取结果后，过滤掉 IPv6 地址的接口标识符（例如：%en8）
//            let ipAddress = String(cString: hostname)
//            if let range = ipAddress.range(of: "%") {
//                return String(ipAddress[..<range.lowerBound]) // 只保留实际的 IP 地址部分
//            }
//            
//            return ipAddress
        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
            data.withUnsafeBytes { (pointer: UnsafeRawBufferPointer) -> Void in
                let sockaddr = pointer.bindMemory(to: sockaddr.self).baseAddress!
                if getnameinfo(sockaddr, socklen_t(data.count), &hostname, socklen_t(hostname.count), nil, 0, NI_NUMERICHOST) == 0 {
                    print("✅ 解析出的 IP 地址: \(String(cString: hostname))")
                } else {
                    print("❌ 无法解析 IP 地址")
                }
            }
            
            let ipAddress = String(cString: hostname)
            
            // 如果是 IPv6 地址，返回空字符串或者其他提示
            if ipAddress.contains(":") {
                print("❌ 这是一个 IPv6 地址，无法使用")
                return nil
            }
            
        if ipAddress.hasPrefix("192") {
            print("❌ 本地无法使用")
            return nil
        }
            return ipAddress
    }
}

extension DDLoggerSocketManager: NetServiceBrowserDelegate {
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {
        print("发现服务: \(service.name)")
                self.netService = service
                service.delegate = self
                service.resolve(withTimeout: 5.0)
    }
}

extension DDLoggerSocketManager: NetServiceDelegate {
    func netServiceWillResolve(_ sender: NetService) {
            print("Will resolve \(sender)")
        }

        func netServiceDidResolveAddress(_ sender: NetService) {
            let hostName = sender.hostName
            print("Did resolve \(sender) \(hostName) \(sender.addresses)")
            guard  let addresses = sender.addresses else { print("无法解析地址"); return }
            for address in addresses {
                if let ipAddress = self.getIPAddress(from: address) {
                    let port = sender.port
                    print("服务的 IP 地址: \(ipAddress), 端口: \(port)")
                    
                    // 创建连接URL
                    if let url = URL(string: "ws://\(ipAddress):\(port)") {
                        let name = "\(hostName)-\(sender.domain)"
                        // 创建WebSocket任务
                        let webSocketTask = session.webSocketTask(with: url)
                        // 开始接收消息
                        self.receiveMessage(task: ConnectionItem(name: name, task: webSocketTask))
                        // 启动WebSocket任务
                        webSocketTask.resume()
                        self.sendLogMessage("DDLoggerClient_tcp_auth", task: webSocketTask)
                        self.sendHeartBeat(task: webSocketTask)
                        //添加到链接列表
                        if !self.webSocketTaskList.contains(where: { item in
                            return item.name == "name"
                        }) {
                            self.webSocketTaskList.append(ConnectionItem(name: name, task: webSocketTask))
                            //连接列表
                            if let bonjourDidConnectHandler = self.bonjourDidConnectHandler {
                                bonjourDidConnectHandler("\(name)")
                            }
                        }
                    }
                    break
                }
                
            }
        }
    
    func netService(_ sender: NetService, didNotResolve errorDict: [String : NSNumber]) {
        print("error", errorDict)
    }
}
