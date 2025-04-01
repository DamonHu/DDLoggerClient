//
//  ContentView.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct ContentView: View {
    @State private var list: [DDLoggerClientItem] = []
    @State private var filterText: String = ""
    @State private var filterType: String = "ALL"
    @State private var selectedPath: String?
    @State private var needReload: Bool = false
    //收藏的 window 窗口
    @Binding var favList: [DDLoggerClientItem]
    //查看的window窗口
    @Binding var selectedItem: DDLoggerClientItem
    
    var body: some View {
        
        NavigationSplitView {
            NavMenuListView(list: $list, selectedPath: $selectedPath).onChange(of: selectedPath) { newValue in
                self.needReload = true
                self.updateList()
            }.frame(minWidth: 300)
        } detail: {
            DDLoggerClientList(list: $list, favList: $favList, filterText: $filterText, selectedType: $filterType, needReload: $needReload, selectedItem: $selectedItem).onChange(of: filterText) { newValue in
                print("searchText updated to: \(newValue)")
                self.updateList()
            }.onChange(of: filterType) { newValue in
                print("searchType updated to: \(newValue)")
                self.updateList()
            }
        }

        
//        NavigationView {
//            
//            
//        }.navigationTitle("DDLoggerClient")
    }
}

extension ContentView {
    func updateList() {
        guard let path = selectedPath else {
            list = []
            return
        }
        if path.hasSuffix(".db") {
            //解析log日志
            let tool = SQLiteTool(path: URL.init(fileURLWithPath: path))
            list = tool.getLogs(keyword: self.filterText, type: DDLogType.type(title: self.filterType))
        } else if path.hasSuffix(".log") {
            //解析log文件
            let tool = LogParseTool(path: URL.init(fileURLWithPath: path))
            list = tool.getLogs(keyword: self.filterText, type: DDLogType.type(title: self.filterType))
        }
    }
}
