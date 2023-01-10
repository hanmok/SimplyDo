//
//  FetchingEnum.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/31.
//

import Foundation

struct TodoPredicate {
    var shouldSortAscendingOrder: Bool
    var completion: CompletionStatus
    
    init(shouldSortAscendingOrder: Bool = false, completion: CompletionStatus = .none) {
        self.shouldSortAscendingOrder = shouldSortAscendingOrder
        self.completion = completion
    }
}

enum CompletionStatus {
    case done
    case todo
    case none
}
