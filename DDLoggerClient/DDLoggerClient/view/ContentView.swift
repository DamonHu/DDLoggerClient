//
//  ContentView.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct ContentView: View {
    @State private var list: [DDLoggerClientItem] = []
    @State private var searchText: String = ""
    @State private var selectedPath: String?
    
    var body: some View {
        NavigationView {
            NavMenuListView(list: $list, selectedPath: $selectedPath).onChange(of: selectedPath) { newValue in
                self.updateList()
            }
            DDLoggerClientList(list: $list, searchText: $searchText).onChange(of: searchText) { newValue in
                print("searchText updated to: \(newValue)")
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
            list = tool.getLogs(keyword: self.searchText)
        } else if path.hasSuffix(".log") {
            //解析log文件
            let tool = LogParseTool(path: URL.init(fileURLWithPath: path))
            list = tool.getLogs(keyword: self.searchText)
        }
    }
}
