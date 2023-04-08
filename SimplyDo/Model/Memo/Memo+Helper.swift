//
//  Memo+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/07.
//

import Foundation
import CoreData

extension Memo {
    
    public var contents: String {
        get { self.contents_ ?? "" }
        set { self.contents_ = newValue }
    }
    
    public var createdAt: Date {
        get { self.createdAt_ ?? Date() }
        set { self.createdAt_ = newValue}
    }
    
    public var id: UUID {
        get { self.id_ ?? UUID() }
        set { self.id_ = newValue }
    }
    
    public var title: String {
        get { self.title_ ?? "" }
        set { self.title_ = newValue}
    }
    
    public var updatedAt: Date {
        get { self.updatedAt_ ?? Date() }
        set { self.updatedAt_ = newValue}
    }
    
//    private var workspace: Workspace {
//        get { self.workspace_ ?? Workspace() }
//        set { self.workspace_ = newValue }
//    }
    
    public var workspaceTitle: String {
        get { self.workspace_?.title ?? "Default" }
        set { self.workspace_?.title = newValue }
    }
    
    
//    public var tags: Set<Tag> {
//        get { self.tags_ as? Set<Tag> ?? [] }
//        set { self.tags_ = newValue as NSSet }
//    }
}


