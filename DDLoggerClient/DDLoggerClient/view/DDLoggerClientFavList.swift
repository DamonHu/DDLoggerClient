//
//  DDLoggerClientFavList.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct DDLoggerClientFavList: View {
    @Environment(\.openWindow) private var openWindow
    
    @Binding var list: [DDLoggerClientItem]
    @Binding var selectedItem: DDLoggerClientItem
    
    @State var searchText: String = ""
    @State private var tempSearchText: String = ""
    @State private var selectedIndex: Int? = nil        //滚动索引到第几个
    @State private var filteredIndices: [Int] = []  // 存储搜索结果的索引
    @State private var isShowDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            //查找
            HStack(alignment: .center, spacing: 10) {
                Image("icon_delete")
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    .onTapGesture {
                        self.isShowDeleteAlert = true
                    }.alert("清空记录", isPresented: $isShowDeleteAlert) {
                        Button("确认清空", role: .destructive) {
                            self.list = []
                            self.searchText = ""
                            self.tempSearchText = ""
                            self.selectedIndex = nil
                            self.filteredIndices = []
                        }
                        Button("取消", role: .cancel) {

                        }
                    } message: {
                        Text("请确认是否清空收藏记录")
                    }
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
                LazyVStack {
                    ForEach(list.indices, id: \.self) { index in
                        let item = list[index]
                        DDLoggerClientCell(item: item, isSelected: self.selectedIndex.map { self.filteredIndices[$0] } == index, number: list.count - index, onButtonClicked: {
                            // 父视图处理按钮点击
                            self.selectedItem = item
                            openWindow(id: "itemPreview")
                        }).id(index).contextMenu {
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
                                        self.list.remove(at: index)
                                    }) {
                                        Text("取消置顶")
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
            }
            .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                .onChange(of: selectedIndex) { newValue in
                    guard let index = self.selectedIndex else {
                        return
                    }
                    if self.filteredIndices.isEmpty { return }
                    let filteredIndice = self.filteredIndices[index]
                    withAnimation {
                        proxy.scrollTo(filteredIndice, anchor: .center)
                    }
                }
        }
        
        
    }
}
