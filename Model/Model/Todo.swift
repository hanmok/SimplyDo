//
//  Todo.swift
//  Model
//
//  Created by Mac mini on 2022/12/26.
//

import Foundation

public struct Todo {
    public var title: String
    public var targetDate: Date
    public var isDone: Bool = false
    public var description: String
    
    public init(title: String, targetDate: Date, isDone: Bool = false, description: String) {
        self.title = title
        self.targetDate = targetDate
        self.isDone = isDone
        self.description = description
    }
}
