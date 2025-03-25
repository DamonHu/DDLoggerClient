//
//  DDLoggerClientItem.swift
//  DDLoggerClientSwift
//
//  Created by Damon on 2020/6/10.
//  Copyright © 2020 Damon. All rights reserved.
//

import Foundation
import CommonCrypto
import SwiftUI

let t = Date()

enum Section: CaseIterable {
    case main
}
///log的内容
public class DDLoggerClientItem {
    let identifier = UUID()                                 //用于hash计算
    var databaseID: Int = 0                                 //存在database的id
    public var mLogItemType = DDLogType.debug             //log类型
    public var mLogFile: String = ""                        //log调用的文件
    public var mLogLine: String = ""                        //log调用的行数
    public var mLogFunction: String = ""                    //log调用的函数名
    public var mLogContent: String = "DDLoggerSwift: Click Log To Copy"  //log的内容
    public var mCreateDate = t                      //log日期
    
    private var mCurrentHighlightString = ""            //当前需要高亮的字符串
    private var mCacheHasHighlightString = false        //上次查询是否包含高亮的字符串
    private var mCacheHighlightCompleteString = NSMutableAttributedString(string: "")   //上次包含高亮支付的富文本
}

extension DDLoggerClientItem {
    func getLogContent() -> String {
        var contentString = ""
        if self.mLogItemType == .privacy {
            contentString = mLogContent.aesCBCDecrypt(password: DDLoggerClient.privacyLogPassword, ivString: DDLoggerClient.privacyLogIv, encodeType: DDLoggerClient.privacyResultEncodeType) ?? "Invalid encryption"
        } else {
            contentString = mLogContent
        }
        return contentString
    }
    
    func icon() -> String {
        switch mLogItemType {
        case .info:
            return "✅"
        case .warn:
            return "⚠️"
        case .error:
            return "❌"
        case .privacy:
            return "⛔️"
        default:
            return "💜"
        }
    }
    
    func level() -> String {
        switch mLogItemType {
        case .info:
            return "INFO"
        case .warn:
            return "WARN"
        case .error:
            return "ERROR"
        case .privacy:
            return "PRIVACY"
        default:
            return "DEBUG"
        }
    }
    
    func getCreateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateStr = dateFormatter.string(from: mCreateDate)
        return dateStr
    }
    
    func getMessageMeta() -> String {
        //日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateStr = dateFormatter.string(from: mCreateDate)
        return "🕛 \(dateStr)" + " - " + "📋 File:\(self.mLogFile)" + " - " + "📏 Line:\(self.mLogLine)" + " - " + "💡 Function: \(self.mLogFunction)"
    }
    
    //获取完整的输出内容
    public func getFullContentString() -> String {
        //所有的内容
        //日期
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        let dateStr = dateFormatter.string(from: mCreateDate)
        //所有的内容
         return "\(self.icon())" + " " + "[\(dateStr)]" + " " + "[\(self.level())]" + " " +  "File: \(mLogFile) | Line: \(mLogLine) | Function: \(mLogFunction) " + "\n---------------------------------\n" + self.getLogContent() + "\n"
    }
    
    //根据需要高亮内容查询组装高亮内容
    public func getHighlightAttributedString(highlightString: String, complete:(Bool, NSAttributedString)->Void) -> Void {
        if highlightString.isEmpty {
            //空的直接返回
            
            let contentString = self.getFullContentString()
            let newString = NSMutableAttributedString(string: contentString, attributes: [NSAttributedString.Key.font : Font.system(size: 13)])
            self.mCacheHighlightCompleteString = newString
            self.mCacheHasHighlightString = false
            complete(self.mCacheHasHighlightString, newString)
        } else if highlightString == self.mCurrentHighlightString{
            //和上次高亮相同，直接用之前的回调
            complete(self.mCacheHasHighlightString, self.mCacheHighlightCompleteString)
        } else {
            self.mCurrentHighlightString = highlightString
            let contentString = self.getFullContentString()
            let newString = NSMutableAttributedString(string: contentString, attributes: [NSAttributedString.Key.font :Font.system(size: 13)])
            let regx = try? NSRegularExpression(pattern: highlightString, options: NSRegularExpression.Options.caseInsensitive)
            if let searchRegx = regx {
                self.mCacheHasHighlightString = false;
                searchRegx.enumerateMatches(in: contentString, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: contentString.count)) { (result: NSTextCheckingResult?, flag, stop) in
                    newString.addAttribute(NSAttributedString.Key.foregroundColor, value: Color(red: 255.0/255.0, green: 0.0, blue: 0.0), range: result?.range ?? NSRange(location: 0, length: 0))
                    if result != nil {
                        self.mCacheHasHighlightString = true
                    }
                    self.mCacheHighlightCompleteString = newString
                    complete(self.mCacheHasHighlightString, newString)
                }
            } else {
                self.mCacheHighlightCompleteString = newString
                self.mCacheHasHighlightString = false
                complete(self.mCacheHasHighlightString, newString)
            }
        }
    }
}
