//
//  DDLoggerClientList.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct DDLoggerClientList: View {
    @Environment(\.openWindow) private var openWindow
    @Binding var list: [DDLoggerClientItem]
    @Binding var favList: [DDLoggerClientItem]
    @Binding var filterText: String
    @Binding var selectedType: String
    @Binding var needReload: Bool
    @Binding var selectedItem: DDLoggerClientItem
    
    @State var searchText: String = ""
    @State private var tempFilterText: String = ""
    @State private var tempSearchText: String = ""
    @State private var selectedIndex: Int? = nil        //滚动索引到第几个
    @State private var filteredIndices: [Int] = []      // 存储搜索结果的索引
    
    let options = ["ALL", "INFO", "WARN", "ERROR", "PRIVACY"]
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            HStack(alignment: .center, spacing: 10) {
                Text("过滤")
                    .frame(width: 50, alignment: .center)
                TextField("输入过滤内容，回车确定", text: $tempFilterText, onCommit: {
                    self.filterText = self.tempFilterText
                })
                    .frame(height: 24)
                    .border(.gray, width: 0.5)
                    .textFieldStyle(.plain)
                
                Picker("日志等级", selection: $selectedType) {
                     ForEach(0..<options.count, id: \.self) { index in
                         Text(options[index]).tag(options[index])
                      }
                }
                .pickerStyle(MenuPickerStyle()) // 使用下拉样式
                Button("清空过滤条件") {
                    self.resetFilter()
                }.frame(height: 30)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            //查找
            HStack(alignment: .center, spacing: 10) {
                Text("查找")
                    .frame(width: 50, alignment: .center)
                TextField("输入查找内容，回车确定", text: $tempSearchText, onCommit: {
                    self.searchText = self.tempSearchText
                    //搜索内容
                    self.selectedIndex = nil
                    self.filteredIndices = []
                    for i in 0..<list.count {
                        let item = list[i]
                        if item.getLogContent().contains(self.searchText) {
                            self.filteredIndices.append(i)
                        }
                    }
                    if !self.filteredIndices.isEmpty {
                        self.selectedIndex = 0
                    }
                })
                    .frame(height: 24)
                    .border(.gray, width: 0.5)
                    .textFieldStyle(.plain)
                Text(" \(self.selectedIndex == nil ? "" : "\(self.selectedIndex! + 1)" + "/" + "\(self.filteredIndices.count)")")
                    .frame(width: 50, alignment: .center)
                    .foregroundColor(Color.gray)
                Button("上一条") {
                    guard let index = self.selectedIndex else { return }
                    //
                    if self.selectedIndex == 0 {
                        self.selectedIndex = self.filteredIndices.count - 1
                    } else {
                        self.selectedIndex = index - 1
                    }
                }.disabled(self.selectedIndex == nil).frame(height: 30).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                Button("下一条") {
                    guard let index = self.selectedIndex else {
                        return
                    }
                    if self.selectedIndex == self.filteredIndices.count - 1 {
                        self.selectedIndex = 0
                    } else {
                        self.selectedIndex = index + 1
                    }
                }.disabled(self.selectedIndex == nil).frame(height: 30).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        }
        
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(pinnedViews: []) {
                    ForEach(list.indices, id: \.self) { index in
                        let item = list[index]
                        DDLoggerClientCell(item: item, isSelected: self.selectedIndex.map { self.filteredIndices[$0] } == index, number: list.count - index, onButtonClicked: {
                            // 父视图处理按钮点击
                            self.selectedItem = item
                            openWindow(id: "itemPreview")
                        })
                            .id(index).contextMenu {
                                VStack(alignment: .trailing, spacing: 10) {
                                    Button(action: {
                                        let pasteBoard = NSPasteboard.general
                                        pasteBoard.clearContents()
                                        pasteBoard.setString(item.getFullContentString(), forType: .string)
                                        print("Copied to clipboard: \(item.getFullContentString())")
                                    }) {
                                        Text("复制日志")
                                    }
                                    Button(action: {
                                        self.favList.append(item)
                                        var favListWindowsShow = false
                                        NSApp.windows.forEach { window in
                                            if let identifier = window.identifier?.rawValue {
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
                                    }) {
                                        Text("收藏日志")
                                    }
                                    Button(action: {
                                        self.selectedItem = item
                                        openWindow(id: "itemPreview")
                                    }) {
                                        Text("查看详情")
                                    }
                                }
                            }
                    }
                }
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
            .onChange(of: selectedIndex) { newValue in
                    guard let index = self.selectedIndex else {
                        return
                    }
                    if self.filteredIndices.isEmpty { return }
                    let filteredIndice = self.filteredIndices[index]
                    withAnimation {
                        proxy.scrollTo(filteredIndice, anchor: .center)
                    }
                }.onChange(of: needReload) { newValue in
                    if needReload {
                        self.resetFilter()
                        self.resetSearch()
                        proxy.scrollTo(0, anchor: .top)
                        self.needReload = false
                    }
                }
        }
        
        
    }
}

extension DDLoggerClientList {
    func resetSearch() {
        self.tempSearchText = ""
        self.searchText = self.tempSearchText
        //搜索内容
        self.selectedIndex = nil
        self.filteredIndices = []
    }
    
    func resetFilter() {
        self.tempFilterText = ""
        self.filterText = ""
        self.selectedType = "ALL"
    }
    
}
