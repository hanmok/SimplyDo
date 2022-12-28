//
//  Tag+Helper.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/29.
//

import Foundation

extension Tag {
    public var id: UUID {
        get {
            self.id_ ?? UUID()
        }
        set {
            self.id_ = UUID()
        }
    }
}
