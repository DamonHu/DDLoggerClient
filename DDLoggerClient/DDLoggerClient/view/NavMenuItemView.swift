//
//  NavMenuItemView.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct NavMenuItemView: View {
    var url: URL
    @Binding var selectedPath: String?
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            Circle()
                .foregroundColor(selectedPath == url.path ? .green : .gray)
                .frame(width: 13, height: 13, alignment: .leading)
            Text(url.lastPathComponent)
                .foregroundColor(selectedPath == url.path ? .black : .gray)
                .font(selectedPath == url.path ? .system(size: 14, weight: .bold): .system(size: 13))
                .lineLimit(2)
        }.padding(EdgeInsets(top: 16, leading: 10, bottom: 16, trailing: 10)).frame(maxWidth: .infinity, alignment: .leading) // 让 HStack 占满整个宽度
            .contentShape(Rectangle())
        
    }
}

//struct NavMenuItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavMenuItemView(url: URL(string: "https://www.baidu.com")!, selectedPath: .constant(""))
//    }
//}
