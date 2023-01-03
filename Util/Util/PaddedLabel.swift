//
//  PaddedLabel.swift
//  Util
//
//  Created by Mac mini on 2023/01/03.
//


import UIKit

public class PaddedLabel: UILabel {
    
    var topInset = 5.0
    var bottomInset = 5.0
    var leftInset = 10.0
    var rightInset = 10.0
    
    convenience init(top: CGFloat, bottom: CGFloat, left: CGFloat, right: CGFloat) {
        self.init()
    }
    
    public override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
    
    public override var bounds: CGRect {
        didSet {
            preferredMaxLayoutWidth = bounds.width - (leftInset + rightInset)
        }
    }
}
