//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import UIKit
import FSCalendar

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}

class CustomFSCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    
    public var contents: [String] = [] {
        didSet {
            print("contents \(contents) have been assigned to cell")
            
        }
    }
    
    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            print("changeColor called")
            changeColor()
        }
    }
    
    override var isPlaceholder: Bool {
        didSet {
            print("setPlaceHolderColor called")
            setPlaceHolderColor()
        }
    }
    
    func setPlaceHolderColor() {
        if self.isPlaceholder {
            backgroundColor = .clear
            self.titleLabel.textColor = UIColor.clear
        }
    }
    
    func changeColor() {
        if isSelected {
            backgroundColor = UIColor.indigo
        } else {
            backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("FSCalendarCell init called")
//        let circleImageView = UIImageView(image: UIImage(named: "circle")!)
//        let circleImageView = UIImageView(image: UIImage(systemName: "circle")!)
        
        let circleImageView = UIView()
        self.contentView.insertSubview(circleImageView, at: 0)
//        self.circleImageView = circleImageView
        
        let selectionLayer = CAShapeLayer()
        
        selectionLayer.fillColor = UIColor.black.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        self.selectionLayer = selectionLayer
        
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.lightGray.withAlphaComponent(0.12)
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        self.circleImageView.frame = self.contentView.bounds
        
        let contentsHeight = self.contentView.frame.height / 5
        let width = self.contentView.frame.width
        
        // date count need to be above
        for idx in 0 ..< contents.count {
            let label = UILabel(frame: CGRect(x: 5, y: contentsHeight * CGFloat(idx + 1), width: width - 5, height: contentsHeight))
            label.isUserInteractionEnabled = false
            label.lineBreakMode = .byClipping
            self.addSubview(label)
            label.text = contents[idx]
        }
        
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = self.contentView.bounds
        
        
        if selectionType == .middle {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
        }
        else if selectionType == .leftBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .rightBorder {
            self.selectionLayer.path = UIBezierPath(roundedRect: self.selectionLayer.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: self.selectionLayer.frame.width / 2, height: self.selectionLayer.frame.width / 2)).cgPath
        }
        else if selectionType == .single {
            let diameter: CGFloat = min(self.selectionLayer.frame.height, self.selectionLayer.frame.width)
            self.selectionLayer.path = UIBezierPath(ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2, y: self.contentView.frame.height / 2 - diameter / 2, width: diameter, height: diameter)).cgPath
            self.selectionLayer.fillColor = UIColor.black.cgColor
        }
//        print("selectionType")
        
        
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the built-in appearance configuration
        // 전, 다음 달 날짜들
        if self.isPlaceholder {
            backgroundColor = .clear
            self.titleLabel.textColor = UIColor.clear
            
//            self.eventIndicator.isHidden = true
//            self.titleLabel.textColor = UIColor.lightGray
//            self.titleLabel.textColor = .magenta
        }
    }
}
