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
import Model

// MARK: - Delegate

class DoneTableCell: UITableViewCell {
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            let attr = NSAttributedString(string: item.title, attributes: [.strikethroughStyle: 1, .font: UIFont.systemFont(ofSize: 20, weight: .regular)])
            self.titleLabel.attributedText = attr
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(todoIcon)
        contentView.addSubview(titleLabel)
        contentView.clipsToBounds = true
        
        accessoryType = .none
    }
    
    public lazy var todoIcon: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: UIImage(systemName: "checkmark.circle.fill"))
        imgView.contentMode = .scaleAspectFit
        imgView.translatesAutoresizingMaskIntoConstraints = false
        
        btn.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return btn
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
