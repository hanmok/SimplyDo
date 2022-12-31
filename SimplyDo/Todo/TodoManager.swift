//
//  TodoManager.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation
import CoreData
import Util

public struct TodoManager {
    
    let mainContext: NSManagedObjectContext
    
    init(mainContext: NSManagedObjectContext = TodoCoreDataStack.shared.mainContext) {
        
        self.mainContext = mainContext
        print("todoManager initialized")
    }
}


extension TodoManager {
    @discardableResult
    public func createTodo(title: String, targetDate: Date = Date()) throws -> Todo {
        let todo = Todo(context: mainContext)
        todo.title = title
        todo.targetDate = targetDate
        todo.isDone = false
       
        do {
            try mainContext.save()
            return todo
        } catch let error {
            print("Failed to create todo with title: \(title), error: \(error.localizedDescription)")
            throw TodoError.create
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
    
    func fetchTodos() -> [Todo] {
        let fetchRequest = NSFetchRequest<Todo>(entityName: String.EntityName.todo)
        // inverse order
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: String.TodoAttributes.id, ascending: false)]
        
        do {
            let todos = try mainContext.fetch(fetchRequest)
            return todos
        } catch let error {
            fatalError("fail to get gatherings, \(error.localizedDescription)")
        }
    }
}
