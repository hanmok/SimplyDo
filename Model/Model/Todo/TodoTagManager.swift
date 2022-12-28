//
//  TodoManager.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation
import CoreData

public struct TodoTagManager {
    let mainContext: NSManagedObjectContext
    public init(mainContext: NSManagedObjectContext = TodoCoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
}


extension TodoTagManager {
    @discardableResult
    public func createTag(title: String ) -> TodoTag? {
        let todoTag = TodoTag(context: mainContext)
        todoTag.title = title
        do {
            try mainContext.save()
            return todoTag
        } catch let error {
            print("Failed to create todo with title: \(title), error: \(error.localizedDescription)")
            return nil
        }
    }
    
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
}
