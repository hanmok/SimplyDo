//
//  CoreDataManager.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/11.
//

import Foundation
import CoreData
import Util

public class CoreDataManager {
    let mainContext: NSManagedObjectContext
    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.mainContext = mainContext
    }
}

// static 으로 하는게 낫지 않나??
extension CoreDataManager {
    @discardableResult
    func createTodo(title: String, targetDate: Date = Date()) throws -> Todo {
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
    func toggleDoneState(todo: Todo) throws -> Todo? {
        todo.isDone = !todo.isDone
        do {
            try mainContext.save()
            return todo
        } catch let error {
            throw TodoError.update(error.localizedDescription)
        }
    }
    
    func delete(todo: Todo) throws {
        mainContext.delete(todo)
        do {
            try mainContext.save()
        } catch let error {
            throw TodoError.delete(error.localizedDescription)
        }
    }
    
    // TODO: add fetching conditions like specific date, or month, all done lists
    func fetchTodos(predicate: TodoPredicate = (TodoPredicate())) throws -> [Todo] {
        let fetchRequest = NSFetchRequest<Todo>(entityName: String.EntityName.todo)
        
        switch (predicate.shouldSortAscendingOrder, predicate.completion) {
            case (let isAscending, let status):
                if [CompletionStatus.done, CompletionStatus.todo].contains(status) {
                    let arg = status == .done ? true : false
                    fetchRequest.predicate = NSPredicate(format: "\(String.TodoAttributes.isDone) == %@", NSNumber(value: arg))
                }
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: .TodoAttributes.createdAt, ascending: isAscending)]
        }
        do {
            let todos = try mainContext.fetch(fetchRequest)
            return todos
        } catch let error {
            throw TodoError.read(error.localizedDescription)
        }
    }
}


extension Todo {
    public static func printNames(todos: [Todo], message: String) {
        print(message)
        todos.forEach {
            print($0.title)
        }
    }
}


extension CoreDataManager {
    
    @discardableResult
    func createMemo(contents: String) -> Memo? {
        guard let validContents = getSeparateText(from: contents) else { return nil }
        let newMemo = Memo(context: mainContext)
        newMemo.title = validContents[0]
        newMemo.contents = validContents[1]
        newMemo.createdAt = Date()
        do {
            try mainContext.save()
            print("createdMemo: \(newMemo)")
            return newMemo
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateMemo(contents: String, memo: Memo) {
        let test = getSeparateText(from: contents)
        print("test: \(String(describing: test))")
        guard let validContents = getSeparateText(from: contents) else {
            // TODO: remove
            
            self.deleteMemo(memo: memo)
            return
        }
        
        memo.title = validContents[0]
        memo.contents = validContents[1]
        memo.updatedAt = Date()
        
        do {
            try mainContext.save()
            print("memo updated to title:\(memo.title), contents:\(memo.contents)")
            return
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteMemo(memo: Memo) {
        mainContext.delete(memo)
        print("memo deleted!")
        do {
            try mainContext.save()
            return
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // TODO: Add more options (updatedDate, tag)
    func fetchMemos() -> [Memo] {
        
        let fetchRequest = NSFetchRequest<Memo>(entityName: String.EntityName.memo)
        
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .MemoAttributes.createdAt, ascending: false)]
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .MemoAttributes.updatedAt, ascending: false)]
        
        do {
            let memos = try mainContext.fetch(fetchRequest)
            return memos
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
