//
//  ModelTests.swift
//  ModelTests
//
//  Created by Mac mini on 2022/12/26.
//

import XCTest
import CoreData
@testable import Model

final class ModelTests: XCTestCase {

    var todoManager: TodoManager!
//    var stack: TodoDataTestStack?
    
    override func setUp() {
        super.setUp()
        let stack = TodoDataTestStack()
        
        todoManager = TodoManager(mainContext: stack.mainContext)
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
//    func test_unitTest() {
//        XCTAssertEqual(1 + 2, 3)
//        XCTAssertEqual(1 + 2, 4)
//    }
    
    func test_makeTodo() {
        
        do {
            let newTodo = try todoManager.createTodo(title: "Test")
            XCTAssertEqual(newTodo.title, "Test")
        } catch let e {
            print(e)
            
        }
        //        newTodo
    }
}
