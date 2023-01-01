//
//  DesignKit.swift
//  DesignKit
//
//  Created by Mac mini on 2023/01/01.
//

import Foundation
import UIKit
import SnapKit

protocol DesignKit {
//    func buildView(themeColor: ThemeColor) -> UIView
//    func buildRedView() -> UIView
    func makeRequestButton(image: UIImage) -> UIButton
    func uiView(color: UIColor) -> UIView
}

// Some Codes are for pratice.
public enum ThemeColor {
    case bgColor1
    case bgColor2
    
    var color: UIColor {
        switch self {
            case .bgColor1:
                return .systemIndigo
            case .bgColor2:
                return .systemCyan
        }
    }
}

public class DesignKitImp: DesignKit {
    
    public init() {}
    
    public func floatingButton(image: UIImage, color: UIColor = UIColor.black) -> UIButton {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = color
        
        btn.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return btn
    }
    
    public func makeRequestButton(image: UIImage) -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .blue
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        return view
    }
    
    public func uiView(color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }
    
//    public func buildView(themeColor: ThemeColor) -> UIView {
//        let view = UIView()
//        view.backgroundColor = themeColor.color
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }
//
//    public func buildRedView() -> UIView {
//        let view = UIView()
//        view.backgroundColor = .red
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }
}
