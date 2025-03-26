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
        HStack(alignment: .center, spacing: 10) {
            Circle()
                .foregroundColor(selectedPath == url.path ? .green : .gray)
                .frame(width: 10, height: 10, alignment: .leading)
            Text(url.lastPathComponent)
                .foregroundColor(selectedPath == url.path ? .black : .gray)
                .lineLimit(2)
        }.padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
        
    }
}

//struct NavMenuItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavMenuItemView(url: URL(string: "https://www.baidu.com")!, selectedPath: .constant(""))
//    }
//}
