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
    public func createTodo(title: String, targetDate: Date = Date()) -> Todo? {
        let todo = Todo(context: mainContext)
        todo.title = title
        todo.targetDate = targetDate
        todo.isDone = false
        do {
            try mainContext.save()
            return todo
        } catch let error {
            print("Failed to create todo with title: \(title), error: \(error.localizedDescription)")
            return nil
        }
    }
}
