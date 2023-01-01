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

// MARK: - Delegate

protocol TodoTableCellDelegate: AnyObject {
    func checkmarkTapped(_ cell: TodoTableCell)
    func titleTapped(_ cell: TodoTableCell)
}

class TodoTableCell: UITableViewCell {
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            self.titleLabel.text = item.title
            setToggleImage()
        }
    }
    weak var todoCellDelegate: TodoTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkmarkButton)
        layoutToggleImage()
        checkmarkButton.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        backgroundColor = .cyan
    }
    
    @objc func checkmarkTapped() {
        todoCellDelegate?.checkmarkTapped(self)
    }
    
    var toggleImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    func setToggleImage() {
        guard let todoItem = todoItem else {return }
        let image = todoItem.isDone ? UIImage.unchecked : UIImage.checked
        toggleImageView.image = image
    }
    
    func layoutToggleImage() {
        checkmarkButton.addSubview(toggleImageView)
        toggleImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public lazy var checkmarkButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
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
