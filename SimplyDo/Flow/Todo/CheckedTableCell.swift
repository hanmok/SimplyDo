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
            let attr = NSAttributedString(string: item.title,
                                          attributes: [
                                            .strikethroughStyle: 1,
                                            .font: UIFont.systemFont(ofSize: 20, weight: .regular),
                                            .foregroundColor: UIColor(white: 0.6, alpha: 1)
                                          ])
            self.titleLabel.attributedText = attr
        }
    }
    
    public weak var todoCellDelegate: CheckedTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [lottieView, todoIcon, titleLabel].forEach { self.contentView.addSubview($0)}
//        contentView.clipsToBounds = true
//        todoIcon.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
//        accessoryType = .none
//        backgroundColor = UIColor(white: 0.85, alpha: 0.9)
    }
    
    @objc func checkmarkTapped() {
        todoCellDelegate?.checkmarkTapped(self)
    }

    public var todoIcon = UIButton()
    
    private let lottieView = LottieAnimationView(name: "check").then {
        $0.loopMode = .playOnce
        $0.contentMode = .scaleAspectFit
        $0.transform = CGAffineTransform(scaleX: 2, y: 2)
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset2 = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.frame = contentView.frame.inset(by: inset2)
        
        contentView.clipsToBounds = true
        todoIcon.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        accessoryType = .none
        contentView.backgroundColor = UIColor(white: 0.85, alpha: 0.7)
        
        let inset = 7
        let width = 26
        
        todoIcon.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
            make.width.equalTo(width)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
            make.width.equalTo(width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(todoIcon.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        // set done state
        lottieView.currentProgress = 1
        todoIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
