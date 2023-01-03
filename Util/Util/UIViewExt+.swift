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
    case all
    case none
}

extension UIView {
    public func applyCornerRadius(on side: Side, radius: CGFloat = 10.0) {
        self.layer.cornerRadius = radius
        switch side {
            case .all:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .top:
                self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom:
                self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            case .none:
                self.layer.maskedCorners = []
        }
        self.clipsToBounds = true
    }
}
