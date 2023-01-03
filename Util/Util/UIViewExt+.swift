//
//  UIViewExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/03.
//


import UIKit

public enum Side {
    case top
    case bottom
}

extension UIView {
    public func applyCornerRadius(on side: [Side], radius: CGFloat) {
        self.layer.cornerRadius = radius

        if side.contains(.top) {
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        if side.contains(.bottom) {
            self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
        self.clipsToBounds = true
    }
}
