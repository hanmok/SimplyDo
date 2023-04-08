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
    func createTodo(title: String, workspace: String, targetDate: Date = Date()) throws -> Todo {
        let todo = Todo(context: mainContext)
        todo.title = title
        todo.targetDate = targetDate
        todo.isDone = false
        todo.createdAt = Date()
        let matchingWorkspace = self.findWorkspace(workspace)
        todo.workspace = matchingWorkspace
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
    // TODO: need to fetch if Date().day <= dueDate.day
    func fetchTodos(predicate: TodoPredicate = (TodoPredicate())) throws -> [Todo] {
        let fetchRequest = NSFetchRequest<Todo>(entityName: String.EntityName.todo)
        
        switch (predicate.shouldSortAscendingOrder, predicate.completion) {
            case (let isAscending, let status):
                if [CompletionStatus.done, CompletionStatus.todo].contains(status) {
                    let arg = status == .done ? true : false
                    let statusPredicate = NSPredicate(format: "\(String.TodoAttributes.isDone) == %@", NSNumber(value: arg))
                    
//                    let workspacePredicate = NSPredicate(format: "\(String.TodoAttributes.workspaceTitle) == %@", predicate.workspaceTitle)
//                    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [statusPredicate, workspacePredicate])
//                    fetchRequest.predicate = compoundPredicate
                    
                    fetchRequest.predicate = statusPredicate
                }
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: .TodoAttributes.createdAt, ascending: isAscending)]
        }
        do {
            let todos = try mainContext.fetch(fetchRequest)
            
            if predicate.workspaceTitle == "All" {
                print("flag 1, returning \(todos.count)")
                
                return todos
            } else {
                let matchingWorkspace = self.findWorkspace(predicate.workspaceTitle)
                return todos.filter { $0.workspace == matchingWorkspace}
            }
            
        } catch let error {
            throw TodoError.read(error.localizedDescription)
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
        newMemo.updatedAt = Date()
        do {
            try mainContext.save()
            return newMemo
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateMemoWorkspace(memo: Memo, _ workspace: String) {
        
//        guard let matchingWorkspace = self.findWorkspace(workspace) else {
//            fatalError()
//        }
        let matchingWorkspace = self.findWorkspace(workspace)
        memo.workspace = matchingWorkspace
        
        do {
            try mainContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateTodoWorkspace(todo: Todo, _ workspace: String) {
        
//        guard let matchingWorkspace = self.findWorkspace(workspace) else {
//            fatalError()
//        }
        
        let matchingWorkspace = self.findWorkspace(workspace)
        todo.workspace = matchingWorkspace
        
        do {
            try mainContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func renewUpdatedDate(memo: Memo) {
        memo.updatedAt = Date()
        do {
            try mainContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func updateMemo(contents: String, memo: Memo) {
        let test = getSeparateText(from: contents)
        guard let validContents = getSeparateText(from: contents) else {
            // TODO: remove
            self.deleteMemo(memo: memo)
            return
        }
        
        memo.title = validContents[0]
        memo.contents = validContents[1]
            
        do {
            try mainContext.save()
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteMemo(memo: Memo) {
        mainContext.delete(memo)
//        print("memo deleted!")
        do {
            try mainContext.save()
            return
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    // TODO: Add more options (updatedDate, tag)
    func fetchMemos(workspaceTitle: String? = nil) -> [Memo] {
        
        let fetchRequest = NSFetchRequest<Memo>(entityName: String.EntityName.memo)
        
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .MemoAttributes.createdAt, ascending: false)]
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .MemoAttributes.updatedAt, ascending: false)]
        
        do {
            let memos = try mainContext.fetch(fetchRequest)
            // if has workspaceTitle, fetch them only
            if let workspaceTitle = workspaceTitle {
                let matchedMemos = memos.filter { $0.workspace?.title == workspaceTitle }
                return matchedMemos
            }
            return memos
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}

// MARK: - Workspace
extension CoreDataManager {
    @discardableResult
    func createWorkspace(title: String) -> Workspace {
        let newWorkspace = Workspace(context: mainContext)
        newWorkspace.title = title
        newWorkspace.createdAt = Date()
        
        // 기본적으로 가지고 있는 Default Workspace 도 필요하다..
        // 삭제 불가능하도록.
        
        do {
            try mainContext.save()
            return newWorkspace
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteWorkspace(title: String) {
        
    }
    
    func fetchWorkspace() -> [Workspace] {
        let fetchRequest = NSFetchRequest<Workspace>(entityName: String.EntityName.workspace)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: String.WorkspaceAttributes.createdAt, ascending: true)]
        do {
            let workspaces = try mainContext.fetch(fetchRequest)
            return workspaces
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func findWorkspace(_ title: String) -> Workspace {
        let fetchRequest = NSFetchRequest<Workspace>(entityName: String.EntityName.workspace)
        
        do {
            let workspaces = try mainContext.fetch(fetchRequest)
//            guard let matched = workspaces.first(where: { each in
//                each.title == title
//            }) else {
//                fatalError()
//            }
            
            if let matched = workspaces.first(where: { each in each.title == title}) {
                return matched
            } else {
                return workspaces.first!
            }
            
            
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
}
