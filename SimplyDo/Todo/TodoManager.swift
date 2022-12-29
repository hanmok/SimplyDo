//
//  TodoManager.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation
import CoreData

public struct TodoManager {
    let mainContext: NSManagedObjectContext
    public init(mainContext: NSManagedObjectContext = TodoCoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
}


extension TodoManager {
    @discardableResult
    public func createTodo(title: String, targetDate: Date = Date(), tag: TodoTag? = nil) -> Todo? {
        let todo = Todo(context: mainContext)
        todo.title = title
        todo.targetDate = targetDate
        todo.isDone = false
        if let tag = tag {
            todo.tag = tag.title
        }
        do {
            try mainContext.save()
            return todo
        } catch let error {
            print("Failed to create todo with title: \(title), error: \(error.localizedDescription)")
            return nil
        }
    }
    
    @discardableResult
    public func toggleDoneState(todo: Todo) -> Todo? {
        todo.isDone = !todo.isDone
        do {
            try mainContext.save()
                return todo
        } catch let error {
            print("Failed to create todo with title: \(todo.title), error: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func delete(todo: Todo) {
        mainContext.delete(todo)
        do {
            try mainContext.save()
        } catch let error {
            print("Failed to delete todo with title: \(todo.title), error: \(error.localizedDescription)")
        }
    }
}
