//
//  StrintExt+.swift
//  Util
//
//  Created by Mac mini on 2022/12/31.
//

import Foundation

extension String {
    public struct EntityName {
        public static let todo = "Todo"
        public static let memo = "Memo"
    }
    public struct TodoAttributes {
        public static let createdAt = "createdAt_"
        public static let dueDate = "dueDate"
        public static let id = "id_"
        public static let isDone = "isDone_"
        public static let isImportant = "isImportant_"
        public static let targetDate = "targetDate_"
        public static let title = "title_"
        public static let tags = "tags"
    }
    
    public struct MemoAttributes {
        public static let contents = "contents_"
        public static let createdAt = "createdAt_"
        public static let id = "id_"
        public static let title = "title_"
        public static let updatedAt = "updatedAt_"
        public static let tags = "tags"
    }
    
    public struct TagAttributes {
        public static let createdAt = "createdAt_"
        public static let id = "id_"
        public static let title = "title_"
        public static let todos = "todos_"
        public static let memos = "memos_"
    }
}

public func getSeparateText(from string: String, using separator: Character = "\n") -> [String]? {
    
    print(#function +  "input:\(string)")

    if string.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
        return nil
    }
    
    let separated = string.split(separator: "\n", maxSplits: 1)
    print("separated result: \(separated)")
    if separated.count == 2 {
        return [String(separated.first!), String(separated.last!)]
    } else if separated.count == 1 {
        if string.starts(with: "\n") {
            return ["", String(separated.first!)]
        }
        return [String(separated.first!), ""]
    } else { // separated.count == 0 -> return all contents
        return ["", string]
    }
}


extension StringProtocol where Index == String.Index {
    public func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
