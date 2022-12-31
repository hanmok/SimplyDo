//
//  TodoError.swift
//  Model
//
//  Created by Mac mini on 2022/12/30.
//

import Foundation

public typealias ErrorMessaage = String
enum TodoError: Error {
    case create(ErrorMessaage)
    case update(ErrorMessaage)
    case delete(ErrorMessaage)
    case read(ErrorMessaage)
    
    var message: String {
        return self.localizedDescription
    }
}
