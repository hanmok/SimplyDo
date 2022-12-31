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


// static 으로 하는게 낫지 않나??
extension TodoManager {
    @discardableResult
    public func createTodo(title: String, targetDate: Date = Date()) throws -> Todo {
        let todo = Todo(context: mainContext)
        todo.title = title
        todo.targetDate = targetDate
        todo.isDone = false
        todo.createdAt = Date()
       
        do {
            try mainContext.save()
            return todo
        } catch let error {
            throw TodoError.create(error.localizedDescription)
        }
    }
    
    @discardableResult
    public func toggleDoneState(todo: Todo) throws -> Todo? {
        todo.isDone = !todo.isDone
        do {
            try mainContext.save()
                return todo
        } catch let error {
            throw TodoError.update(error.localizedDescription)
        }
    }
    
    public func delete(todo: Todo) throws {
        mainContext.delete(todo)
        do {
            try mainContext.save()
        } catch let error {
            throw TodoError.delete(error.localizedDescription)
        }
    }
    
    // TODO: add fetching conditions like specific date, or month, all done lists
    func fetchTodos() throws -> [Todo] {
        let fetchRequest = NSFetchRequest<Todo>(entityName: String.EntityName.todo)
        // inverse order
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: String.TodoAttributes.createdAt, ascending: false)]
        do {
            let todos = try mainContext.fetch(fetchRequest)
            return todos
        } catch let error {
            throw TodoError.read(error.localizedDescription)
        }
    }
}
