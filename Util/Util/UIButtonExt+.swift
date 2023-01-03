//
//  UIButtonExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/03.
//

import SnapKit
import UIKit


extension UIButton {
    public convenience init(image: UIImage, tintColor: UIColor, hasBoundary: Bool, hasInset: Bool) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = tintColor
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            if hasInset {
                make.top.bottom.leading.trailing.equalToSuperview().inset(10)
            } else {
                make.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        if hasBoundary {
            let borderColor = UIColor(white: 0.3, alpha: 0.5).cgColor
            self.addBoundary(cornerRadius: 5, borderWidth: 1, borderColor: borderColor)
        }
    }
    
    public func addBoundary(cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: CGColor) {
        self.layer.cornerRadius = cornerRadius
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = borderColor
    }
}