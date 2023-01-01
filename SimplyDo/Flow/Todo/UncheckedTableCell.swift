//
//  TodoTableCell.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/27.
//

import Foundation
import UIKit
import SnapKit
import Then
import DesignKit

// MARK: - Delegate

protocol UncheckedTableCellDelegate: AnyObject {
    func checkmarkTapped(_ cell: UncheckedTableCell)
    func titleTapped(_ cell: UncheckedTableCell)
}

class UncheckedTableCell: UITableViewCell {
    
    let designKit = DesignKitImp()
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            self.titleLabel.text = item.title
        }
    }
    weak var todoCellDelegate: UncheckedTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkmarkButton)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        checkmarkButton.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        backgroundColor = .cyan
    }
    
    @objc func checkmarkTapped() {
        todoCellDelegate?.checkmarkTapped(self)
    }
    
    public lazy var checkmarkButton: UIButton = {
        return self.designKit.Button(image: UIImage.unchecked, hasInset: false)
    }()
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        checkmarkButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview()
        }
        checkmarkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
