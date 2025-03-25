//
//  SQLiteTool.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/31.
//

import Foundation
import SQLite3

class SQLiteTool {
    private var logDBPath: URL
    private var logDB: OpaquePointer?
    private var indexDB: OpaquePointer?
    
    init(path: URL) {
        self.logDBPath = path
        //开始新的数据
        self.logDB = self._openDatabase()
    }
    
    //获取第一个id，以便判断是否有更多
    func getMinLogID() -> Int {
        let databasePath = self.logDBPath
        guard FileManager.default.fileExists(atPath: databasePath.path) else {
            return 0
        }
        let queryDB = self._openDatabase()
        let queryString = "SELECT IFNULL(MIN(id), 0) FROM DDLog"
        
        var queryStatement: OpaquePointer?
        var minID: Int?
        
        if sqlite3_prepare_v2(queryDB, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                minID = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        
        sqlite3_finalize(queryStatement)
        return minID ?? 0
    }

    func getLogs(keyword: String? = nil, type: DDLogType? = nil, startID: Int? = nil, pageSize: Int? = nil) -> [DDLoggerClientItem] {
        let databasePath = self.logDBPath
        guard FileManager.default.fileExists(atPath: databasePath.path) else {
            //数据库文件不存在
            return []
        }
        let queryDB = self._openDatabase()
        var queryString = "SELECT * FROM DDLog"
        //查询条件
        var whereClauses: [String] = []
        if let keyword = keyword, !keyword.isEmpty {
            whereClauses.append("content LIKE '%\(keyword)%'")
        }
        if let type = type {
            whereClauses.append("logType == \(type.rawValue)")
        }
        if let startID = startID {
            whereClauses.append("id < \(startID)")
        }
        // 如果有条件，拼接 WHERE 子句
        if !whereClauses.isEmpty {
            queryString += " WHERE " + whereClauses.joined(separator: " AND ") + " ORDER BY id DESC"
        } else {
            queryString = queryString + " ORDER BY id DESC"
        }
        if let pageSize = pageSize {
            queryString = queryString + " LIMIT \(pageSize)"
        }
        
        var queryStatement: OpaquePointer?
        //第一步
        var logList = [DDLoggerClientItem]()
        if sqlite3_prepare_v2(queryDB, queryString, -1, &queryStatement, nil) == SQLITE_OK {
            //第二步
            while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                //第三步
                let item = DDLoggerClientItem()
                item.databaseID = Int(sqlite3_column_int(queryStatement, 0))
                item.mLogItemType = DDLogType.init(rawValue: Int(sqlite3_column_int(queryStatement, 1)))
                //时间
                let time = sqlite3_column_double(queryStatement, 2)
                item.mCreateDate = Date(timeIntervalSince1970: time)
                item.mLogFile = String(cString: sqlite3_column_text(queryStatement, 3))
                item.mLogLine = String(cString: sqlite3_column_text(queryStatement, 4))
                item.mLogFunction = String(cString: sqlite3_column_text(queryStatement, 5))
                //更新内容
                item.mLogContent = String(cString: sqlite3_column_text(queryStatement, 6))
                logList.append(item)
            }
        }
        //第四步
        sqlite3_finalize(queryStatement)
        return logList
    }
    
    func getItemCount(keyword: String? = nil, type: DDLogType? = nil) -> Int {
        return self._getItemCount(keyword: keyword, type: type)
    }
}

private extension SQLiteTool {
    //打开数据库
    func _openDatabase() -> OpaquePointer? {
        let dbPath = self.logDBPath
        if FileManager.default.isReadableFile(atPath: dbPath.path) {
            var db: OpaquePointer?
            if sqlite3_open_v2(dbPath.path, &db, SQLITE_OPEN_READWRITE|SQLITE_OPEN_CREATE|SQLITE_OPEN_FULLMUTEX, nil) == SQLITE_OK {
    //            print("成功打开数据库\(dbPath.absoluteString)")
                return db
            } else {
                print("打开数据库失败")
                return nil
            }
        } else {
            print("没有读取权限")
            
            return nil
        }
        
    }
}

//MARK: - 全文搜索相关
private extension SQLiteTool {
    func _getItemCount(keyword: String? = nil, type: DDLogType? = nil) -> Int {
        var count = 0
        let databasePath = self.logDBPath
        guard FileManager.default.fileExists(atPath: databasePath.path) else {
            //数据库文件不存在
            return count
        }
        let queryDB = self.logDB
        var queryString = "SELECT COUNT(*) FROM DDLog"
        var whereClauses: [String] = []
        if let keyword = keyword, !keyword.isEmpty {
            whereClauses.append("content LIKE '%\(keyword)%'")
        }
        if let type = type {
            whereClauses.append("logType == \(type.rawValue)")
        }
        // 如果有条件，拼接 WHERE 子句
        if !whereClauses.isEmpty {
            queryString += " WHERE " + whereClauses.joined(separator: " AND ")
        }
        var queryStatement: OpaquePointer?
        //第一步
        if sqlite3_prepare_v2(queryDB, queryString, Int32(strlen(queryString)), &queryStatement, nil) == SQLITE_OK {
            //第二步
            while(sqlite3_step(queryStatement) == SQLITE_ROW) {
                //第三步
                //虚拟表中未存储id
                count = Int(sqlite3_column_int(queryStatement, 0))
            }
        }
        //第四步
        sqlite3_finalize(queryStatement)
        return count
    }
}
