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
        
        [titleLabel, contentsLabel, workspaceLabel].forEach { contentView.addSubview($0)}
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.trailing.equalToSuperview().inset(100)
        }
        
        contentsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(12)
        }
        
        workspaceLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.top.equalToSuperview().inset(8)
        }
        
        workspaceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = CustomFont.memoCellTitle
        view.numberOfLines = 2
        return view
    }()
    
    private let contentsLabel: UILabel = {
        let view = UILabel()
        view.font = CustomFont.memoCellContents
        view.numberOfLines = 5
        view.textColor = UIColor(white: 0.32, alpha: 1)
        return view
    }()
    
    private func configureLayout(memo: Memo) {
        titleLabel.text = memo.title
        contentsLabel.text = memo.contents
//        if let memoWorkspace = memo.workspace {
//            workspaceLabel.text = memoWorkspace.title
//        }
        workspaceLabel.text = memo.workspaceTitle
    }
    
    private let workspaceLabel: UILabel = {
        let view = UILabel()
        view.font = CustomFont.memoCellworkspaceCaption.bold()
        view.textColor = UIColor.mainOrange
        return view
    }()
}





/*
          8
 
      contentView
 
          8
 
8     titleLabel   100
 
           3
 
8    contentsLabel   8
 
           12
 
            8 (contentView)
 */
