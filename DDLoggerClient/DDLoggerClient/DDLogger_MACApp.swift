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
    @State private var favFilterText: String = ""
    @State private var favFilterType: String = "ALL"
    
    var body: some Scene {
        WindowGroup {
            ContentView(favList: $favList, favFilterText: $favFilterText, favFilterType: $favFilterType)
        }
        // 独立设置窗口
        WindowGroup("收藏列表", id: "favList") {
            DDLoggerClientFavList(list: $favList, filterText: $favFilterText, selectedType: $favFilterType).onChange(of: favFilterText) { newValue in
                
            }.onChange(of: favFilterType) { newValue in
                
            }
        }
    }
}
