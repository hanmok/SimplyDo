////
////  MemoManager.swift
////  SimplyDo
////
////  Created by Mac mini on 2023/01/10.
////
//
//import Foundation
//import CoreData
//import Util
//
//public struct MemoManager {
//    let mainContext: NSManagedObjectContext
//    init(mainContext: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
//        self.mainContext = mainContext
//    }
//}
//
//extension MemoManager {
//    @discardableResult
//    func createMemo(title: String, contents: String) -> Memo {
//        
//        let newMemo = Memo(context: mainContext)
//        newMemo.title = title
//        newMemo.contents = contents
//        newMemo.createdAt = Date()
//        
//        do {
//            try mainContext.save()
//            
//            return newMemo
//        } catch let error {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    @discardableResult
//    func createMemo(contents: String) -> Memo {
//        
//        // 여기 라인에서부터 ..
//        guard contents.count != 0 else { fatalError() }
//        let newMemo = Memo(context: mainContext)
//        if contents.contains("\n") {
//            let overallContents = contents.split(separator: "\n", maxSplits: 2)
//            if let title = overallContents.first, let contents = overallContents.last {
//                newMemo.title = String(title)
//                newMemo.contents = String(contents)
//            }
//        } else {
//            newMemo.title = contents
//        }
//        
//        newMemo.createdAt = Date()
//        
//        do {
//            try mainContext.save()
//            return newMemo
//        } catch let error {
//            fatalError(error.localizedDescription)
//        }
//    }
//    
//    // TODO: Add more options (updatedDate, tag)
//    func fetchMemos() -> [Memo] {
//        
//        let fetchRequest = NSFetchRequest<Memo>(entityName: String.EntityName.memo)
//        
//        fetchRequest.sortDescriptors = [NSSortDescriptor(key: .MemoAttributes.createdAt, ascending: true)]
//        
//        do {
//            let memos = try mainContext.fetch(fetchRequest)
//            return memos
//        } catch let error {
//            fatalError(error.localizedDescription)
//        }
//    }
//}
