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
