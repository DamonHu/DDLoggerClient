//
//  DDLoggerClientCell.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import SwiftUI

struct DDLoggerClientCell: View {
    var item: DDLoggerClientItem
    var isSelected: Bool
    var number: Int
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text("#\(number)" + "   " + item.getMessageMeta())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.background(item.mLogItemType.color()).cornerRadius(3)
                
            Text(item.getLogContent())
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color.black)
                .background(isSelected ? Color(red: 193/255.0, green: 70.0/255.0, blue: 0.0/255.0, opacity: 0.9) : Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
        }
    }
}

//struct DDLoggerClientCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DDLoggerClientCell(item: DDLoggerClientItem())
//    }
//}
