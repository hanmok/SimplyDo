//
//  DateExt+.swift
//  Util
//
//  Created by Mac mini on 2023/02/11.
//

import Foundation

extension Date {
    public func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    public func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    public func makeNumber() -> Int? {
        let components = self.get(.day, .month, .year)
        guard let year = components.year, let month = components.month, let day = components.day else { return nil }
        let str = "\(year)\(month)\(day)"
        return Int(str) ?? nil
    }
    
    public func getFormattedNumber() -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let str = formatter.string(from: self)
        guard let ret = Int(str) else { fatalError()}
//        return Int(str)!
        return ret
    }
    
    
}
