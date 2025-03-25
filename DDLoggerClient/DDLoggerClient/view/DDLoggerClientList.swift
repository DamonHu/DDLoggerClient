//
//  DDLoggerClientList.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct DDLoggerClientList: View {
    @Binding var list: [DDLoggerClientItem]
    @Binding var searchText: String
    
    @State private var typeText: String = ""
    
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("搜索")
                .frame(width: 50, alignment: .center)
            TextField("输入查找内容，回车确定", text: $typeText, onCommit: {
                self.searchText = self.typeText
            })
                .frame(height: 24)
                .border(.gray, width: 0.5)
                .textFieldStyle(.plain)
                .onChange(of: searchText) { newValue in
                    print("searchText has been updated to: \(newValue)")
                }
            Button("重置") {
                self.typeText = ""
                self.searchText = ""
            }.frame(height: 30)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))
        }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
        List(list, id: \.identifier) { item in
            DDLoggerClientCell(item: item)
        }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
    }
}
