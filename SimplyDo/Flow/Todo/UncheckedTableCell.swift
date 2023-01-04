//
//  TodoTableCell.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/27.
//
import Util
import UIKit
import SnapKit
import Then
import DesignKit
import Lottie

// MARK: - Delegate

protocol UncheckedTableCellDelegate: AnyObject {
    func checkmarkTapped(_ cell: UncheckedTableCell)
    func titleTapped(_ cell: UncheckedTableCell)
}

class UncheckedTableCell: UITableViewCell {
    
    let isBiggerMode = true
    let designKit = DesignKitImp()
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            self.titleLabel.text = item.title
            self.lottieView.currentProgress = 0
        }
    }
    
    weak var todoCellDelegate: UncheckedTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [lottieView, checkmarkButton, titleLabel].forEach { self.contentView.addSubview($0)}
        contentView.clipsToBounds = true
        checkmarkButton.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        backgroundColor = UIColor(white: 0.85, alpha: 0.7)
    }

    @objc func checkmarkTapped() {
        print("checkmark Tapped!")
        lottieView.isHidden = false
        lottieView.play { _ in
            self.todoCellDelegate?.checkmarkTapped(self)
        }
    }
    
    private let checkmarkButton: UIButton = {
        let btn = UIButton()
        btn.addBoundary(cornerRadius: 13,
                        borderWidth: 1,
                        borderColor: UIColor(white: 0.7, alpha: 1).cgColor)
        return btn
    }()
    
    private let lottieView = LottieAnimationView(name: "check").then {
        $0.isHidden = true
        $0.animationSpeed = 1.5
        $0.loopMode = .playOnce
        $0.contentMode = .scaleAspectFit
        $0.transform = CGAffineTransform(scaleX: 2, y: 2)
        $0.currentProgress = 0
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        print("layoutSubViews called")
        let inset = isBiggerMode ? 7 : 10
        let width = isBiggerMode ? 26 : 20
        
        checkmarkButton.snp.makeConstraints { make in
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
            make.leading.equalTo(checkmarkButton.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
        }
        checkmarkButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
