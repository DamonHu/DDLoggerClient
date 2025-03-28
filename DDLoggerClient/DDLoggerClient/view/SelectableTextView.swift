//
//  SelectableTextView.swift
//  DDLoggerClient
//
//  Created by Damon on 2025/3/28.
//

import SwiftUI

// 创建一个包装 NSTextView 的 SwiftUI 组件
struct SelectableTextView: NSViewRepresentable {
    @Binding var text: String

    // 创建 NSTextView 实例
    func makeNSView(context: Context) -> NSTextView {
        let textView = NSTextView()
        textView.font = NSFont.systemFont(ofSize: 16)
        textView.isEditable = false  // 禁止编辑
        textView.isSelectable = true // 允许选择文本
        textView.isRichText = false  // 保持纯文本
        textView.textStorage?.mutableString.setString(text) // 设置初始文本
        return textView
    }

    // 更新 NSTextView 的内容
    func updateNSView(_ nsView: NSTextView, context: Context) {
        if nsView.string != text {
            nsView.string = text // 更新文本
        }
    }
}
