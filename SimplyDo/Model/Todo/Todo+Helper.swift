//
//  Todo+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation
import CoreData


extension Todo {
    public var createdAt: Date {
        get { self.createdAt_ ?? Date() }
        set { self.createdAt_ = newValue }
    }
    
    public var id: UUID {
        get { self.id_ ?? UUID() }
        set { self.id_ = newValue }
    }
    
    public var isDone: Bool {
        get { self.isDone_ }
        set { self.isDone_ = newValue }
    }
    
    public var isImportant: Bool {
        get { self.isImportant_ }
        set { self.isImportant_ = newValue }
    }
    
    public var targetDate: Date {
        get { self.targetDate_ ?? Date() }
        set { self.targetDate_ = newValue }
    }
    
    public var title: String {
        get { self.title_ ?? "" }
        set { self.title_ = newValue }
    }
    
    
//    public var workspace: Workspace {
//        get { self.workspace_ ?? Workspace() }
//        set { self.workspace_ = newValue }
//    }
    
//    public var workspaceTitle: String {
//        get { self.workspace_?.title ?? "Default" }
//        set { self.workspace_?.title = newValue }
//    }
    
//    public var tags: Set<Tag> {
//        get { self.tags_ as? Set<Tag> ?? [] }
//        set { self.tags_ = newValue as NSSet }
//    }
    
}
