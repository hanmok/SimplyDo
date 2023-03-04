//
//  UserDefaultSetup.swift
//  Util
//
//  Created by Mac mini on 2023/03/05.
//


import Foundation

// FIXME: accessToken 여기 넣지 않기.
public struct UserDefaultSetup {

    let defaults = UserDefaults.standard
    
    public init(){}
    
    enum UserDefaultKey: String {
        case lastUsedWorkspace
    }
    
    public var lastUsedWorkspace: String {
        get {
            return defaults.string(forKey: UserDefaultKey.lastUsedWorkspace.rawValue) ?? "none"
        }
        set {
            defaults.set(newValue, forKey: UserDefaultKey.lastUsedWorkspace.rawValue)
        }
    }

}
