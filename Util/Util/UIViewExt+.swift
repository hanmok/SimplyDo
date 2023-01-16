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

// 출처: https://ios-development.tistory.com/653 // 이거,, 대각선도 추가해줘야 할 것 같다.
extension UIView {
    public enum VerticalLocation {
        case bottom
        case top
        case left
        case right
    }

    public func addShadow(location: VerticalLocation, color: UIColor = .black, opacity: Float = 0.8, radius: CGFloat = 5.0) {
        switch location {
        case .bottom:
             addShadow(offset: CGSize(width: 0, height: 10), color: color, opacity: opacity, radius: radius)
        case .top:
            addShadow(offset: CGSize(width: 0, height: -10), color: color, opacity: opacity, radius: radius)
        case .left:
            addShadow(offset: CGSize(width: -10, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            addShadow(offset: CGSize(width: 10, height: 0), color: color, opacity: opacity, radius: radius)
        }
        
    }

    public func addShadow(offset: CGSize, color: UIColor = .black, opacity: Float = 0.5, radius: CGFloat = 3.0) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
