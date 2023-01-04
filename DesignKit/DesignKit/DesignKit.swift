//
//  DesignKit.swift
//  DesignKit
//
//  Created by Mac mini on 2023/01/01.
//

import Foundation
import UIKit
import SnapKit

public protocol DesignKit {
//    func buildView(themeColor: ThemeColor) -> UIView
//    func buildRedView() -> UIView
    func FloatingButton(image: UIImage, color: UIColor) -> UIButton
    func Button(image: UIImage, hasBoundary: Bool, hasInset: Bool, inset: CGFloat) -> UIButton
    func View(color: UIColor) -> UIView
    func PaddedTextField(leftSpacing: CGFloat, rightSpacing: CGFloat) -> UITextField
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
    
    public func FloatingButton(image: UIImage, color: UIColor = .black) -> UIButton {
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
    
    public func Button(image: UIImage, hasBoundary: Bool = false, hasInset: Bool = false, inset: CGFloat = 10) -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: image)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .blue
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            if hasInset {
                make.top.bottom.leading.trailing.equalToSuperview().inset(inset)
            } else {
                make.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        if hasBoundary {
            view.layer.cornerRadius = 5
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        }
        return view
    }
    
    public func View(color: UIColor) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color
        return view
    }
    
    public func PaddedTextField(leftSpacing: CGFloat = 10.0, rightSpacing: CGFloat = 10.0) -> UITextField {
        let view = UITextField()
        
        view.leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftSpacing, height: view.frame.size.height))
        view.rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightSpacing, height: view.frame.size.height))
        view.leftViewMode = .always
        view.rightViewMode = .always
        view.autocorrectionType = .no
        
        // FIXME: Need to hide some bar..
        
        //        var item = view.inputAssistantItem
        //        item.leadingBarButtonGroups = []
        //        item.trailingBarButtonGroups = []
        
        //        view.inputAccessoryView = nil
        //        view.textContentType = .oneTimeCode
        //        view.hi
        //        view.inputView = nil
        ///
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
