//
//  DDLoggerClient_MACApp.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

@main
struct DDLoggerClient_MACApp: App {
    @State private var favList: [DDLoggerClientItem] = []
    @State private var selectedItem: DDLoggerClientItem = DDLoggerClientItem()
    
    var body: some Scene {
        WindowGroup {
            ContentView(favList: $favList, selectedItem: $selectedItem).frame(minWidth:(NSScreen.main?.frame.width ?? 2400) * 2/3, minHeight: (NSScreen.main?.frame.height ?? 1000) * 2/3)
        }.commands {
            CommandGroup(replacing: CommandGroupPlacement.help) {
                Button("访问 GitHub 帮助页面") {
                    openGitHubHelp()
                }.keyboardShortcut("?", modifiers: .command)
                Button("访问东哥笔记") {
                    openBlogHelp()
                }
            }
        }
        
        // 独立设置窗口
        WindowGroup("收藏列表", id: "favList") {
            DDLoggerClientFavList(list: $favList, selectedItem: $selectedItem).frame(minWidth: 1200, minHeight: 1000)
        }
        
        //查看大窗详情
        WindowGroup("查看详情", id: "itemPreview") {
            ContentEditView(item: $selectedItem).frame(minWidth:(NSScreen.main?.frame.width ?? 2400) * 2/3, minHeight: (NSScreen.main?.frame.height ?? 1000) * 2/3)
        }
    }
}

extension DDLoggerClient_MACApp {
    // 打开 GitHub 页面
    func openGitHubHelp() {
        if let url = URL(string: "https://github.com/DamonHu/DDLoggerClient") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func openBlogHelp() {
        if let url = URL(string: "https://dongge.org") {
            NSWorkspace.shared.open(url)
        }
    }
}
