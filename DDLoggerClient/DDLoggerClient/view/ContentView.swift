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
    //收藏的 window 窗口
    @Binding var favList: [DDLoggerClientItem]
    
    var body: some View {
        NavigationView {
            NavMenuListView(list: $list, selectedPath: $selectedPath).onChange(of: selectedPath) { newValue in
                self.updateList()
            }
            DDLoggerClientList(list: $list, favList: $favList, filterText: $filterText, selectedType: $filterType).onChange(of: filterText) { newValue in
                print("searchText updated to: \(newValue)")
                self.updateList()
            }.onChange(of: filterType) { newValue in
                print("searchType updated to: \(newValue)")
                self.updateList()
            }
        }.navigationTitle("DDLoggerClient")
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
