//
//  Tag+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/08.
//

import Foundation

extension Tag {
    public var id: UUID {
        get { self.id_ ?? UUID() }
        set { self.id_ = newValue }
    }
    
    public var title: String {
        get { self.title_ ?? "" }
        set { self.title_ = newValue }
    }
    
    public var memos: Set<Memo> {
        get { memos_ as? Set<Memo> ?? [] }
    }
    
    public var todos: Set<Todo> {
        get { todos_ as? Set<Todo> ?? [] }
    }
}
