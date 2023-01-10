//
//  MemoTableCell.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/10.
//

import UIKit
import Util
import CoreData
import SnapKit

protocol MemoTableCellDelegate: AnyObject {
    func memoTapped(_ cell: MemoTableCell)
}

class MemoTableCell: UITableViewCell {
    public var memoItem: Memo? {
        didSet {
            guard let memo = memoItem else { return }
            configureLayout(memo: memo)
        }
    }
    
    weak var delegate: MemoTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        layer.cornerRadius = 16
        backgroundColor = UIColor(hex6: UIColor.ivoryHex, alpha: 0.7)
        clipsToBounds = true
        
        [titleLabel, contentsLabel].forEach { addSubview($0)}
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(6)
            make.leading.trailing.bottom.equalToSuperview().inset(8)
        }
    }
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 28, weight: .medium)
        view.numberOfLines = 1
        return view
    }()
    
    private let contentsLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 18, weight: .light)
        view.numberOfLines = 0
        return view
    }()
    
    private func configureLayout(memo: Memo) {
        titleLabel.text = memo.title
        contentsLabel.text = memo.contents
    }
}
