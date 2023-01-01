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
    func buildView(themeColor: ThemeColor) -> UIView
    func buildRedView() -> UIView
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
    
    public func buildView(themeColor: ThemeColor) -> UIView {
        let view = UIView()
        view.backgroundColor = themeColor.color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    public func buildRedView() -> UIView {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
}
