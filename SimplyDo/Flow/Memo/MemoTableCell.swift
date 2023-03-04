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
    func memoTapped(_ indexPath: IndexPath)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let inset = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        contentView.frame = contentView.frame.inset(by: inset)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayout() {
        contentView.layer.cornerRadius = 8
        contentView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        contentView.addShadow(offset: CGSize(width: 2.5, height: 2.5), color: UIColor(white: 0.6, alpha: 1))
        
        [titleLabel, contentsLabel].forEach { contentView.addSubview($0)}
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(24)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = CustomFont.memoCellTitle
        view.numberOfLines = 1
        return view
    }()
    
    private let contentsLabel: UILabel = {
        let view = UILabel()
        view.font = CustomFont.memoCellContents
        view.numberOfLines = 5
        return view
    }()
    
    private func configureLayout(memo: Memo) {
        titleLabel.text = memo.title
        contentsLabel.text = memo.contents
    }
}
