//
//  UserDefaultSetup.swift
//  Util
//
//  Created by Mac mini on 2023/03/05.
//


import Foundation


//public struct UserDefaultSetup {
//
//    let defaults = UserDefaults.standard
//
//    public init(){}
//
//    enum UserDefaultKey: String {
//        case lastUsedWorkspace
//    }
//
//    public var lastUsedWorkspace: String {
//        get {
//            return defaults.string(forKey: UserDefaultKey.lastUsedWorkspace.rawValue) ?? "none"
//        }
//        set {
//            defaults.set(newValue, forKey: UserDefaultKey.lastUsedWorkspace.rawValue)
//        }
//    }
//}

extension UserDefaults {
    enum Key: String {
        case lastUsedWorkspace
    }
    
    public var lastUsedWorkspace: String? {
        get {
            return self.string(forKey: .lastUsedWorkspace)
        }
        set {
            self.set(newValue, forKey: .lastUsedWorkspace)
        }
    }
    
    private func set(_ value: Any?, forKey key: Key) {
        self.set(value, forKey: key.rawValue)
        self.synchronize()
    }
    
    private func bool(forKey key: Key) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    private func string(forKey key: Key) -> String? {
        return string(forKey: key.rawValue)
    }
    
}
