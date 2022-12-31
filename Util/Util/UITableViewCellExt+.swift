//
//  UITableViewCell+Ext.swift
//  Util
//
//  Created by Mac mini on 2022/12/27.
//

import UIKit

extension UITableViewCell {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
