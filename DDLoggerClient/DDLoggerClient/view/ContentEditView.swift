//
//  ContentEditView.swift
//  DDLoggerClient
//
//  Created by Damon on 2025/3/31.
//

import SwiftUI

struct ContentEditView: View {
    @Binding var item: DDLoggerClientItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text(item.getMessageMeta())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.frame(maxWidth: .infinity, alignment: .leading).background(item.mLogItemType.color()).cornerRadius(3)
            
            TextEditor(text: .constant(item.getLogContent())).padding()
                .padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 0))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scrollContentBackground(.visible)
                                .foregroundColor(Color.black)
                                .font(.system(size: 14))
                                .lineSpacing(8)
                                .offset(y: 10)
                                .background(Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                
        }
    }
}
