//
//  UIImageViewExt+.swift
//  Util
//
//  Created by Mac mini on 2023/02/10.
//

import UIKit

extension UIImageView {
    public static var leftTriangleImageView: UIImageView {
        let triangleImageView = UIImageView(image: UIImage(systemName: "triangle.fill"))
//        triangleImageView.backgroundColor = UIColor(white: 0.1, alpha: 0.5)
//        triangleImageView.tintColor =
        triangleImageView.tintColor = UIColor(white: 0.1, alpha: 0.4)
//        let triangleImageView = UIImageView(image: UIImage(systemName: ""))
        let transform = CGAffineTransform(rotationAngle: -Double.pi / 2)
        triangleImageView.transform = transform
        triangleImageView.contentMode = .scaleAspectFit
        return triangleImageView
    }
}
