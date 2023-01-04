//
//  TodoTableCell.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/27.
//

import Lottie
import Util
import DesignKit
import Foundation
import UIKit
import SnapKit
import Then

//import Model

// MARK: - Delegate
protocol CheckedTableCellDelegate: AnyObject {
    func checkmarkTapped(_ cell: CheckedTableCell)
    func titleTapped(_ cell: CheckedTableCell)
}

class CheckedTableCell: UITableViewCell {
    
    let designKit = DesignKitImp()
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            let attr = NSAttributedString(string: item.title, attributes: [.strikethroughStyle: 1, .font: UIFont.systemFont(ofSize: 20, weight: .regular)])
            self.titleLabel.attributedText = attr
        }
    }
    
    public weak var todoCellDelegate: CheckedTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [lottieView, todoIcon, titleLabel].forEach { self.contentView.addSubview($0)}
        contentView.clipsToBounds = true
        todoIcon.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        accessoryType = .none
//        backgroundColor = UIColor(white: 0.8, alpha: 1.0)
//        backgroundColor = UIColor.lightBrown
//        backgroundColor = UIColor(white: 0.74, alpha: 1)
        backgroundColor = UIColor(white: 0.85, alpha: 0.9)
    }
    
    @objc func checkmarkTapped() {
        todoCellDelegate?.checkmarkTapped(self)
    }
    
//    public lazy var todoIcon: UIButton = {
////        return self.designKit.Button(image: UIImage.checked)
//
//    }()
    
    
    public var todoIcon: UIButton = {
//        let image = UIImage.checked.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
//        let btn = UIButton(image: image, tintColor: .orange, hasBoundary: false, hasInset: false)
        let btn = UIButton()
    
        return btn
    }()
    
    private let lottieView = LottieAnimationView(name: "check").then {
//        $0.isHidden = true
        //        $0.play(fromFrame: <#T##AnimationFrameTime?#>, toFrame: <#T##AnimationFrameTime#>)
        $0.loopMode = .playOnce
        $0.contentMode = .scaleAspectFit
        $0.transform = CGAffineTransform(scaleX: 2, y: 2)
//        $0.currentProgress = 1
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        todoIcon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(20)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.width.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(todoIcon.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview()
        }
        // set done state
        lottieView.currentProgress = 1
        todoIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
