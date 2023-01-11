//
//  SimplyDoTests.swift
//  SimplyDoTests
//
//  Created by Mac mini on 2022/12/20.
//

import XCTest
import CoreData
@testable import SimplyDo

final class SimplyDoTests: XCTestCase {
    
//    var todoManager: TodoManager!
    var coreDataStack: TodoDataTestStack!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
//        coreDataStack = TodoDataTestStack()
//        todoManager = TodoManager(mainContext: coreDataStack.mainContext)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - Todo
//    func test_creation() {
//        do {
//            let newTodo = try todoManager.createTodo(title: "newTest")
//            XCTAssertEqual(newTodo.title, "newTest")
//        } catch {
//            XCTFail()
//        }
//    }
//
//    func test_fetch() {
//        do {
//            let _ = try todoManager.createTodo(title: "newTest")
//            let _ = try todoManager.createTodo(title: "newTest2")
//            let allTodos = try todoManager.fetchTodos()
//            XCTAssertEqual(allTodos.count, 2)
//        } catch {
//            XCTFail()
//        }
//    }
//
//    func test_advancedFetch() {
//        do {
//            let todo = try todoManager.createTodo(title: "newTest", targetDate: Date(timeIntervalSince1970: 100))
//            let done = try todoManager.createTodo(title: "done", targetDate: Date(timeIntervalSince1970: 200))
//            try todoManager.toggleDoneState(todo: done)
//
//            let doneTodo = try todoManager.fetchTodos(predicate: TodoPredicate(shouldSortAscendingOrder: true, completion: .done))
//            let notDoneTodo = try todoManager.fetchTodos(predicate: TodoPredicate(shouldSortAscendingOrder: true, completion: .todo))
//
//            let allTodos = try todoManager.fetchTodos()
//
//            XCTAssertEqual(doneTodo.count, 1)
//            XCTAssertEqual(doneTodo[0].isDone, true)
//
//            XCTAssertEqual(notDoneTodo.count, 1)
//            XCTAssertEqual(notDoneTodo[0].isDone, false)
//
//            XCTAssertEqual(allTodos.count, 2)
//
//        } catch let error {
//            XCTFail(error.localizedDescription)
//        }
//    }
//
//    func test_updateDone() {
//        do {
//            let newTodo = try todoManager.createTodo(title: "newTest")
//            XCTAssertEqual(newTodo.isDone, false)
//            try todoManager.toggleDoneState(todo: newTodo)
//            XCTAssertEqual(newTodo.isDone, true)
//        } catch {
//            XCTFail()
//        }
//    }
//
//    func test_delete() {
//        do {
//            let newTodo = try todoManager.createTodo(title: "newTest")
//            try todoManager.delete(todo: newTodo)
//            let allTodos = try todoManager.fetchTodos()
//            XCTAssertEqual(allTodos.count, 0)
//        } catch {
//            XCTFail()
//        }
//    }
}


// MARK: - Util
extension SimplyDoTests {
    func test_memoCellSize() {
        let shortString = "asd"
        let emptyString = ""
        let longString = "asndkjwjaeiurliagwivneuriwleubviowaeihorvawitboaerintoiarnobitareintvoaerotvaoetaertblaow;eiurnoi;aweirnbo;eiwmrpv;9eiwrnvaweu9lov9auweotaemovtuawon9ot9aiwna9ivt9inawortawa"
        
        let shortSize = getEstimatedSize(text: shortString)
        let emptySize = getEstimatedSize(text: emptyString)
        let longSize = getEstimatedSize(text: longString)
        XCTAssertEqual(shortSize, emptySize)
        XCTAssertNotEqual(longSize, shortSize)
    }
    
    func getEstimatedSize(text: String) -> CGFloat {
        let approximatedWidthOfBioTextView = 1000 - 16 - 16
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
        
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 20)], context: nil)
        return estimatedFrame.height
    }
}
