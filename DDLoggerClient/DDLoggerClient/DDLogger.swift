//
//  DDLoggerClient.swift
//  DDLoggerClient_MAC
//
//  Created by Damon on 2022/7/30.
//

import Foundation
import SwiftUI

///log的级别，对应不同的颜色
public struct DDLogType : OptionSet {
    public static let debug = DDLogType([])        //only show in debug output
    public static let info = DDLogType(rawValue: 1)    //textColor #50d890
    public static let warn = DDLogType(rawValue: 2)         //textColor #f6f49d
    public static let error = DDLogType(rawValue: 4)        //textColor #ff7676
    public static let privacy = DDLogType(rawValue: 8)      //textColor #42e6a4

    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension DDLogType {
    func color() -> Color {
        switch self {
        case .debug:
            return Color(red: 191.0/255.0, green: 139.0/255.0, blue: 251.0/255.0)
        case .info:
//            return Color(red: 80.0/255.0, green: 216.0/255.0, blue: 144.0/255.0, opacity: 0.8)
            return Color(red: 95.0/255.0, green: 139.0/255.0, blue: 76.0/255.0)
        case .warn:
//            return Color(red: 255.0/255.0, green: 191.0/255.0, blue: 0.0/255.0)
            return Color(red: 217.0/255.0, green: 131.0/255.0, blue: 36.0/255.0)
        case .error:
//            return Color(red: 229.0/255.0, green: 43.0/255.0, blue: 80.0/255.0)
            return Color(red: 169.0/255.0, green: 74.0/255.0, blue: 74.0/255.0)
        case .privacy:
            return Color(red: 9.0/255.0, green: 110.0/255.0, blue: 249.0/255.0)
        default:
            return .black
        }
    }
}

extension DDLogType {
    static func type(title: String) -> DDLogType? {
        if title == "INFO" {
            return .info
        } else if title == "WARN" {
            return .warn
        } else if title == "ERROR" {
            return .error
        } else if title == "PRIVACY" {
            return .privacy
        } else if title == "DEBUG" {
            return .debug
        } else {
            return nil
        }
    }
}
