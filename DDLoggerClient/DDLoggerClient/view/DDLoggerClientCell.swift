//
//  DDLoggerClientCell.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct DDLoggerClientCell: View {
    var item: DDLoggerClientItem
    var isSelected: Bool    //是否被选中
    var number: Int
    @FocusState private var isFocus: Bool
    @State private var textEditorID = UUID()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text("#\(number)" + "   " + item.getMessageMeta())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.frame(maxWidth: .infinity, alignment: .leading).background(item.mLogItemType.color()).cornerRadius(3)
            
            HStack(alignment: .center, spacing: 10) {
                if (isFocus) {
                    Button("退出编辑", role: .cancel) {
                        self.isFocus = false
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                } else {
                    Button("编辑", role: .cancel) {
                        self.isFocus = true
                    }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                }
            }.frame(maxWidth: .infinity, alignment: .leading).background(Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
            
            
            TextEditor(text: .constant(item.getLogContent())).padding()
                .padding(EdgeInsets(top: -20, leading: 0, bottom: 0, trailing: 30))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scrollContentBackground(isFocus ? .automatic : .hidden)
                                .id(textEditorID)
                                .scrollDisabled(!isFocus)
                                .focused($isFocus)
                                .disabled(!isFocus)
                                .foregroundColor(Color.black)
                                .font(.system(size: 14))
                                .lineSpacing(8)
                                .offset(y: 10)
                                .background(isSelected ? Color(red: 193/255.0, green: 70.0/255.0, blue: 0.0/255.0, opacity: 0.9) : Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .onChange(of: isFocus) { isFocus in
                                    if !isFocus {
                                        textEditorID = UUID()
                                    }
                                }
        }
    }
}

//struct DDLoggerClientCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DDLoggerClientCell(item: DDLoggerClientItem())
//    }
//}
