//
//  Workspace+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/02/10.
//

import Foundation


extension Workspace {
    public var createdAt: Date {
        get { self.createdAt_ ?? Date() }
        set { self.createdAt_ = newValue }
    }
    
    public var id: UUID {
        get { self.id_ ?? UUID()}
        set { self.id_ = newValue}
    }
    
    public var title: String {
        get { self.title_ ?? "Workspace" }
        set { self.title_ = newValue }
    }
    
    public var memos: Set<Memo> {
        get { memos_ as? Set<Memo> ?? [] }
        set { memos_ = newValue as NSSet }
    }
    
    public var todos: Set<Todo> {
        get { todos_ as? Set<Todo> ?? [] }
        set { todos_ = newValue as NSSet }
    }
}
