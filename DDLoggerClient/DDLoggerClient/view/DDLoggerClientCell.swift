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
    @State private var isExpanded = false
    @State private var text: String = """
"✅ [2025-03-28 15:50:21.000] [INFO] File: DDAPIPlugin.swift | Line: 57 | Function: didReceive(_:target:)
    ---------------------------------
    Successful response. path: https://dev-api.speakpal.ai/config/langList, headers: Optional(["ua": "i|18.3.2|2.3.6|calteacher|3|414.0|896.0|0|11096|1743148219|199a81a5c8a1f19c7f1e7362ce93ced3|05010a97034892db214bd4fd369cf732|iPhone12,1|en", "Content-type": "application/x-www-form-urlencoded"]), request: requestParameters(parameters: [:], encoding: Alamofire.URLEncoding(destination: Alamofire.URLEncoding.Destination.methodDependent, arrayEncoding: Alamofire.URLEncoding.ArrayEncoding.brackets, boolEncoding: Alamofire.URLEncoding.BoolEncoding.numeric)), response: {
      "debug" : {
        "start" : 1743148219.4168,
        "is_statis" : false,
        "end" : 1743148219.4182,
        "consume" : 0.0014,
        "action" : "Control耗时"
      },
      "msg" : "success",
      "data" : {
        "lang_list" : [
          {
            "id" : "3",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/AR.png",
            "lang_code" : "AR"
          },
          {
            "id" : "4",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/AZ.png",
            "lang_code" : "AZ"
          },
          {
            "id" : "5",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/BG.png",
            "lang_code" : "BG"
          },
          {
            "id" : "7",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/BS.png",
            "lang_code" : "BS"
          },
          {
            "id" : "9",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/CS.png",
            "lang_code" : "CS"
          },
          {
            "id" : "10",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/CY.png",
            "lang_code" : "CY"
          },
          {
            "id" : "11",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/DA.png",
            "lang_code" : "DA"
          },
          {
            "id" : "12",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/DE.png",
            "lang_code" : "DE"
          },
          {
            "id" : "13",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/EL.png",
            "lang_code" : "EL"
          },
          {
            "id" : "72",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/BREN.png",
            "lang_code" : "EN"
          },
          {
            "id" : "14",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/EN.png",
            "lang_code" : "EN"
          },
          {
            "id" : "15",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/ES.png",
            "lang_code" : "ES"
          },
          {
            "id" : "16",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/ET.png",
            "lang_code" : "ET"
          },
          {
            "id" : "17",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/FA.png",
            "lang_code" : "FA"
          },
          {
            "id" : "18",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/FI.png",
            "lang_code" : "FI"
          },
          {
            "id" : "20",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/FR.png",
            "lang_code" : "FR"
          },
          {
            "id" : "24",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/HE.png",
            "lang_code" : "HE"
          },
          {
            "id" : "25",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/HI.png",
            "lang_code" : "HI"
          },
          {
            "id" : "26",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/HR.png",
            "lang_code" : "HR"
          },
          {
            "id" : "28",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/HU.png",
            "lang_code" : "HU"
          },
          {
            "id" : "29",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/HY.png",
            "lang_code" : "HY"
          },
          {
            "id" : "30",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/ID.png",
            "lang_code" : "ID"
          },
          {
            "id" : "31",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/IS.png",
            "lang_code" : "IS"
          },
          {
            "id" : "32",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/IT.png",
            "lang_code" : "IT"
          },
          {
            "id" : "33",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/JA.png",
            "lang_code" : "JA"
          },
          {
            "id" : "37",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/KO.png",
            "lang_code" : "KO"
          },
          {
            "id" : "38",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/LT.png",
            "lang_code" : "LT"
          },
          {
            "id" : "39",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/LV.png",
            "lang_code" : "LV"
          },
          {
            "id" : "40",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/MK.png",
            "lang_code" : "MK"
          },
          {
            "id" : "44",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/MS.png",
            "lang_code" : "MS"
          },
          {
            "id" : "46",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/NL.png",
            "lang_code" : "NL"
          },
          {
            "id" : "47",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/NO.png",
            "lang_code" : "NO"
          },
          {
            "id" : "49",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/PL.png",
            "lang_code" : "PL"
          },
          {
            "id" : "51",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/PT.png",
            "lang_code" : "PT"
          },
          {
            "id" : "52",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/RO.png",
            "lang_code" : "RO"
          },
          {
            "id" : "53",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/RU.png",
            "lang_code" : "RU"
          },
          {
            "id" : "55",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/SK.png",
            "lang_code" : "SK"
          },
          {
            "id" : "56",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/SL.png",
            "lang_code" : "SL"
          },
          {
            "id" : "59",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/SR.png",
            "lang_code" : "SR"
          },
          {
            "id" : "60",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/SV.png",
            "lang_code" : "SV"
          },
          {
            "id" : "62",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/TA.png",
            "lang_code" : "TA"
          },
          {
            "id" : "64",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/TH.png",
            "lang_code" : "TH"
          },
          {
            "id" : "65",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/TR.png",
            "lang_code" : "TR"
          },
          {
            "id" : "66",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/UK.png",
            "lang_code" : "UK"
          },
          {
            "id" : "69",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/VI.png",
            "lang_code" : "VI"
          },
          {
            "id" : "70",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/ZH.png",
            "lang_code" : "ZH"
          },
          {
            "id" : "71",
            "icon_url" : "https://resource.speakpal.ai/call_images/images/languages/ZH-HANT.png",
            "lang_code" : "ZH-HANT"
          }
        ]
      },
      "ok" : 1
    }
"""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                Text("#\(number)" + "   " + item.getMessageMeta())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(Color.white)
                    .font(.system(size: 14))
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
            }.background(item.mLogItemType.color()).cornerRadius(3)
                
//            Text(text)
//                .padding()
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .foregroundColor(Color.black)
//                .background(isSelected ? Color(red: 193/255.0, green: 70.0/255.0, blue: 0.0/255.0, opacity: 0.9) : Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
//                .onTapGesture { expanded.toggle() }
           
            Image(isExpanded ? "icon-zoom" : "icon-scale")
                .resizable()
                .frame(width: 20, height: 20, alignment: .center)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .onTapGesture { isExpanded.toggle() }
            
            TextEditor(text: $text).padding()
                .padding(EdgeInsets(top: -10, leading: 0, bottom: 0, trailing: 20))
                                .frame(maxWidth: .infinity, alignment: .leading)
//                                .scrollContentBackground(.hidden)
                                .scrollIndicators(isExpanded ? .never : .automatic)
                                .foregroundColor(Color.black)
                                .font(.system(size: 14))
                                .lineSpacing(8)
                                .background(isSelected ? Color(red: 193/255.0, green: 70.0/255.0, blue: 0.0/255.0, opacity: 0.9) : Color(red: 246/255.0, green: 246.0/255.0, blue: 246.0/255.0))
                                .frame(maxWidth: .infinity, maxHeight: isExpanded ? .infinity : 200)
        }
    }
}

//struct DDLoggerClientCell_Previews: PreviewProvider {
//    static var previews: some View {
//        DDLoggerClientCell(item: DDLoggerClientItem())
//    }
//}
