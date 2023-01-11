//
//  CircularButton.swift
//  Util
//
//  Created by Mac mini on 2023/01/12.
//


import UIKit

public class CircularButton: UIButton {
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = layer.frame.height / 2
        clipsToBounds = true
    }
    
    public func addImage(_ image: UIImage, tintColor: UIColor? = nil) {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = image
        if let tintColor = tintColor {
            imageView.tintColor = tintColor
        }
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(1.5)
        }
    }
}
