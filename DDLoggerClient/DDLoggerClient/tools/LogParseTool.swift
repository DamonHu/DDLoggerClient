//
//  LogParseTool.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/8/5.
//

import Foundation

class LogParseTool {
    private var logPath: URL

    init(path: URL) {
        self.logPath = path
    }

    func getLogs(keyword: String? = nil, type: DDLogType? = nil) -> [DDLoggerClientItem] {
        if let contentData = try? Data(contentsOf: self.logPath), let content = String(data: contentData, encoding: .utf8) {
            let logs = splitLogEntries(from: content)
            var list = logs.compactMap { parseLogEntry($0) }
            if let keyword = keyword, !keyword.isEmpty {
                list = list.filter({ item in
                    return item.getLogContent().contains(keyword)
                })
            }
            if let type = type {
                list = list.filter({ item in
                    return item.mLogItemType == type
                })
            }
            return list
        }
        return []
    }
}

private extension LogParseTool {
    // 解析单条日志的函数
    func parseLogEntry(_ log: String) -> DDLoggerClientItem? {
        let pattern = #"(\S+) \[(\S+)\] \[([A-Z]+)\] File: (\S+) \| Line: (\d+) \| Function: (\S+)\s*-*\n(.+)"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.dotMatchesLineSeparators]) else {
            return nil
        }
        
        let nsLog = log as NSString
        let matches = regex.matches(in: log, options: [], range: NSRange(location: 0, length: nsLog.length))
        
        guard let match = matches.first, match.numberOfRanges == 8 else {
            return nil
        }
        
        // 提取匹配的内容
//        let test = nsLog.substring(with: match.range(at: 0))
//        let icon = nsLog.substring(with: match.range(at: 1))
        let dateString = nsLog.substring(with: match.range(at: 2))
        let logType = nsLog.substring(with: match.range(at: 3))
        let file = nsLog.substring(with: match.range(at: 4))
        let lineString = nsLog.substring(with: match.range(at: 5))
        let function = nsLog.substring(with: match.range(at: 6))
        let message = nsLog.substring(with: match.range(at: 7))
        
        // 日期解析
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let item = DDLoggerClientItem()
        item.mCreateDate = date
        item.mLogItemType = DDLogType.type(title: logType) ?? .debug
        item.mLogFile = file
        item.mLogLine = lineString
        item.mLogFunction = function
        item.mLogContent = message
        
        return item
    }

    // 使用正则表达式匹配日志头部并分割
    func splitLogEntries(from content: String) -> [String] {
        let pattern = #"(✅|\⛔️|⚠️|❌|💜) \[\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z\]"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
            return []
        }
        
        let nsContent = content as NSString
        let matches = regex.matches(in: content, options: [], range: NSRange(location: 0, length: nsContent.length))
        
        var result: [String] = []
        var lastIndex = 0
        
        for match in matches {
            let range = match.range.location
            if lastIndex < range {
                let logEntry = nsContent.substring(with: NSRange(location: lastIndex, length: range - lastIndex)).trimmingCharacters(in: .whitespacesAndNewlines)
                if !logEntry.isEmpty {
                    result.append(logEntry)
                }
            }
            lastIndex = range
        }
        
        if lastIndex < nsContent.length {
            let lastLogEntry = nsContent.substring(from: lastIndex).trimmingCharacters(in: .whitespacesAndNewlines)
            if !lastLogEntry.isEmpty {
                result.append(lastLogEntry)
            }
        }
        
        return result
    }
}
