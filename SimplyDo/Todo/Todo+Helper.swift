//
//  Todo+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation
import CoreData

extension Todo {
    public var id: UUID {
        get {
            self.id_ ?? UUID()
        }
        set {
            self.id_ = UUID()
        }
    }
    
    public var title: String {
        get {
            self.title_ ?? ""
        }
        set {
            self.title_ = newValue
        }
    }
}
