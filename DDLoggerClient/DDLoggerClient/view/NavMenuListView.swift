//
//  NavMenuListView.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI
import CommonCrypto

struct NavMenuListView: View {
    @Environment(\.openURL) private var openURL
    @Environment(\.openWindow) private var openWindow
    
    @Binding var list: [DDLoggerClientItem]    //显示在列表的log
    //本地加密配置
    @State private var privacyLogPassword = UserDefaults.standard.string(forKey: UserDefaultsKey.privacyLogPassword.rawValue) ?? DDLoggerClient.privacyLogPassword
    @State private var privacyLogIv = UserDefaults.standard.string(forKey: UserDefaultsKey.privacyLogIv.rawValue) ?? DDLoggerClient.privacyLogIv
    @State private var isEncodeBase64 = UserDefaults.standard.bool(forKey: UserDefaultsKey.isEncodeBase64.rawValue)
    //服务器配置
    @State private var fileList: [URL] = [] {
        willSet {
            let pathList = newValue.compactMap({ url in
                try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            })
            UserDefaults.standard.set(pathList, forKey: UserDefaultsKey.fileListHistory.rawValue)
        }
    }
    @Binding var selectedPath: String?
    @State private var dragOver = false
    @State private var showAlert = false
    @State private var isEditConfig = false  //是否编辑修改
    @State private var isConnecting = false  //是否在连接远程服务器
    @State private var isPrivacyError = false
    @State private var isShowFileAlert = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            HStack(alignment: .center, spacing: 0) {
                Button("DDLogger") {
                    self.isConnecting = false
                    self.selectedPath = nil
                }.font(.system(size: 14)).padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)).foregroundColor(Color.white).background(.black).buttonStyle(PlainButtonStyle())
                    
                .frame(height: 40)
                Image("icon_setting")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .onTapGesture {
                        //设置
                        print("点击设置")
                        isEditConfig = !isEditConfig
                    }.padding()
                Image("icon_fav")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .onTapGesture {
                        var favListWindowsShow = false
                        NSApp.windows.forEach { window in
                            if let identifier = window.identifier?.rawValue {
                                print("ss", identifier)
                                if identifier.contains("favList") {
                                    favListWindowsShow = true
                                    window.orderFrontRegardless()
                                    return
                                }
                            }
                        }
                        if !favListWindowsShow {
                            openWindow(id: "favList")
                        }
                    }
//                Image("icon_delete")
//                    .resizable()
//                    .frame(width: 20, height: 20, alignment: .center)
//                    .onTapGesture {
//                        print("delete")
//                        if let path = self.selectedPath, let index = fileList.firstIndex(where: { url in
//                            return url.path == path
//                        }) {
//                            fileList.remove(at: index)
//                        }
//                        self.selectedPath = nil
//                    }
            }.frame(maxWidth: .infinity, alignment: .center)
            //中间内容布局
            if isEditConfig {
                VStack(alignment: .leading, spacing: 10) {
                    //解密配置
                    HStack(alignment: .center, spacing: 10) {
                        Text("")
                            .padding()
                            .frame(width: 5, height: 16, alignment: .center)
                            .background(.red)
                            .cornerRadius(6)
                        Text("加密日志参数配置")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }.padding(.leading, 10)
                    HStack(alignment: .center, spacing: 4) {
                        Text("Password")
                            .frame(width: 70, alignment: .center)
                        TextField("12345678901234561234567890123456", text: $privacyLogPassword)
                            .frame(height: 24)
                            .border(.gray, width: 0.5)
                            .textFieldStyle(.plain)
                        
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    HStack(alignment: .center, spacing: 4) {
                        Text("Iv")
                            .frame(width: 70, alignment: .center)
                        TextField("abcdefghijklmnop", text: $privacyLogIv)
                            .frame(height: 24)
                            .border(.gray, width: 0.5)
                            .textFieldStyle(.plain)
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    HStack(alignment: .center, spacing: 4) {
                        Text("Encode")
                            .frame(width: 70, alignment: .center)
                        HStack(alignment: .center, spacing: 0) {
                            Button("hex") {
                                self.isEncodeBase64 = false
                            }.background(isEncodeBase64 ? .gray : .green)
                                .foregroundColor(.white)
                                .frame(height: 40)
                            Button("base64") {
                                self.isEncodeBase64 = true
                            }.background(isEncodeBase64 ? .green : .gray)
                                .foregroundColor(.white)
                                .frame(height: 40)
                        }
                    }.padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                    //确定
                    HStack(alignment: .center, spacing: 4) {
                        Button("确定") {
                            if privacyLogIv.count != kCCKeySizeAES128 || (privacyLogPassword.count != kCCKeySizeAES128 && privacyLogPassword.count != kCCKeySizeAES192 && privacyLogPassword.count != kCCKeySizeAES256) {
                                isPrivacyError = true
                                return
                            }
                            isEditConfig = false
                            DDLoggerClient.privacyLogPassword = privacyLogPassword
                            DDLoggerClient.privacyLogIv = privacyLogIv
                            DDLoggerClient.privacyResultEncodeType = isEncodeBase64 ? .base64 : .hex
                            
                            UserDefaults.standard.set(typeText, forKey: UserDefaultsKey.socketType.rawValue)
                            UserDefaults.standard.set(privacyLogPassword, forKey: UserDefaultsKey.privacyLogPassword.rawValue)
                            UserDefaults.standard.set(privacyLogIv, forKey: UserDefaultsKey.privacyLogIv.rawValue)
                            UserDefaults.standard.set(isEncodeBase64, forKey: UserDefaultsKey.isEncodeBase64.rawValue)
                        }.foregroundColor(.white)
                            .background(.green)
                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                            .frame(height: 40)
                            .alert("Password available length is \(kCCKeySizeAES128)、\(kCCKeySizeAES192)、\(kCCKeySizeAES256)。 \n Iv should be \(kCCKeySizeAES128) bytes", isPresented: $isPrivacyError) {
                                
                            }
                        Button("取消") {
                            isEditConfig = false
                            switch DDLoggerClient.privacyResultEncodeType {
                            case .base64:
                                isEncodeBase64 = true
                            default:
                                isEncodeBase64 = false
                            }
                        }.foregroundColor(.white)
                            .background(.gray)
                            .frame(height: 40)
                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            //本地日志
            VStack(alignment: .trailing, spacing: 10) {
                List(self.fileList, id: \.path) { i in
                    NavMenuItemView(url: i, selectedPath: $selectedPath)
                        .onTapGesture {
                            selectedPath = i.path
                            if !FileManager.default.fileExists(atPath: i.path) {
                                self.isShowFileAlert = true
                            }
                        }.contextMenu {
                            VStack(alignment: .trailing, spacing: 10) {
                                Button(action: {
                                    NSWorkspace.shared.selectFile(i.path, inFileViewerRootedAtPath: "")
                                }) {
                                    Text("在Finder中显示")
                                }
                                Button(action: {
                                    if let index = fileList.firstIndex(where: { url in
                                        return url.path == i.path
                                    }) {
                                        fileList.remove(at: index)
                                    }
                                    if i.path == self.selectedPath {
                                        self.selectedPath = nil
                                    }
                                }) {
                                    Text("删除引用 (保留源文件)")
                                }
                            }
                        }
                }.alert("文件不存在", isPresented: $isShowFileAlert) {
                    Button("删除", role: .destructive) {
                        if let index = fileList.firstIndex(where: { url in
                            return url.path == selectedPath
                        }) {
                            fileList.remove(at: index)
                        }
                        selectedPath = nil
                    }
                    Button("取消", role: .cancel) {
                        selectedPath = nil
                    }
                } message: {
                    Text("该文件不存在，是否删除引用路径")
                }
                if self.fileList.isEmpty {
                    List {
                        Text("Drag file to here")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 18, weight: .bold))
                        Text("拖拽文件到这里")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .font(.system(size: 18, weight: .bold))
                    }
                }
            }.onDrop(of: ["public.file-url"], isTargeted: $dragOver) { providers in
                providers.first?.loadDataRepresentation(forTypeIdentifier: "public.file-url", completionHandler: { (data, error) in
                    if let data = data, let path = String(data: data, encoding: String.Encoding.utf8), let url = URL(string: path) {
                        if !url.pathExtension.hasPrefix("db") && !url.pathExtension.hasPrefix("log") {
                            showAlert = true
                            return
                        }
                        selectedPath = url.path
                        if !self.fileList.contains(url) {
                            self.fileList.insert(url, at: 0)
                        }
                    }
                })
                return true
            }.alert("仅支持.db和.log文件", isPresented: $showAlert) {
                
            }.onAppear {
                if let pathBookDataList = UserDefaults.standard.object(forKey: UserDefaultsKey.fileListHistory.rawValue) as? [Data] {
                    self.fileList = pathBookDataList.compactMap({ data in
                        var isStale = false
                        let url = try? URL(resolvingBookmarkData: data, options: [.withSecurityScope, .withoutUI], relativeTo: nil, bookmarkDataIsStale: &isStale)
                        if !isStale, url?.startAccessingSecurityScopedResource() == true {
                            return url
                        }
                        return nil
                    })
                }
            }
            //底部
            if isConnecting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .offset(y: -40)
            } else {
                Image("icon_login_cicada")
                    .resizable()
                    .frame(width: 50, height: 50, alignment: .center)
                    .offset(y: -40)
            }
            HStack(alignment: .center) {
                Button("东哥笔记") {
                    openURL(URL(string: "https://dongge.org/blog")!)
                }.offset(y: -30)
                Button("GitHub") {
                    openURL(URL(string: "https://github.com/DamonHu/DDLoggerClient")!)
                }.offset(y: -30)
            }
            
        }
    }
}
