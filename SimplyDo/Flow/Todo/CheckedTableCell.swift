//
//  TodoTableCell.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/27.
//
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
        contentView.addSubview(todoIcon)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        todoIcon.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        accessoryType = .none
    }
    
    @objc func checkmarkTapped() {
        todoCellDelegate?.checkmarkTapped(self)
    }
    
    public lazy var todoIcon: UIButton = {
        return self.designKit.Button(image: UIImage.checked)
    }()
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        todoIcon.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(5)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(todoIcon.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview()
        }
        todoIcon.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
