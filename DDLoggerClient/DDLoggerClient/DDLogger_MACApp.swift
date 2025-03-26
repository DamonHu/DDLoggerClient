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
    
    var body: some Scene {
        WindowGroup {
            ContentView(favList: $favList)
        }
        // 独立设置窗口
        WindowGroup("收藏列表", id: "favList") {
            DDLoggerClientFavList(list: $favList)
        }
    }
}
