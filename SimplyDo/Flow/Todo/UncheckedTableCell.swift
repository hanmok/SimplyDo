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
import AVFoundation

// MARK: - Delegate

protocol UncheckedTableCellDelegate: AnyObject {
    func checkmarkTapped(_ cell: UncheckedTableCell)
    func titleTapped(_ cell: UncheckedTableCell)
}

class UncheckedTableCell: UITableViewCell {
    var player: AVAudioPlayer?
    let designKit = DesignKitImp()
    
    public var todoItem: Todo? {
        didSet {
            guard let item = todoItem else { return }
            self.titleLabel.text = item.title
            self.lottieView.currentProgress = 0
            self.lottieView.isHidden = true
        }
    }
    
    weak var todoCellDelegate: UncheckedTableCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        [lottieView, checkmarkButton, titleLabel].forEach { self.contentView.addSubview($0)}
//        contentView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(40)
//        }
        
//        contentView.snp.makeConstraints { make in
//            make.leading.top.bottom.equalToSuperview()
//            make.trailing.equalToSuperview().inset(30)
//        }
        
//        contentView.clipsToBounds = true
//        checkmarkButton.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
//        backgroundColor = UIColor(white: 0.85, alpha: 0.7)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "checked", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            /* iOS 10 and earlier require the following line:
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }

    @objc func checkmarkTapped() {
        lottieView.isHidden = false
        
        Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(makeSound), userInfo: nil, repeats: false)
        
        lottieView.play { _ in
            self.todoCellDelegate?.checkmarkTapped(self)
        }
    }
    
    @objc func makeSound() {
        self.playSound()
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
        $0.font = CustomFont.todoCellTitle
        $0.textColor = .black
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        let inset2 = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.frame = contentView.frame.inset(by: inset2)
        
        contentView.clipsToBounds = true
        checkmarkButton.addTarget(self, action: #selector(self.checkmarkTapped), for: .touchUpInside)
        contentView.backgroundColor = UIColor(white: 0.85, alpha: 0.7)
        let inset = 7
        let width = 26
        let mainInset = 16
        
        checkmarkButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
//            make.leading.equalToSuperview().inset(inset + mainInset)
            make.width.equalTo(width)
        }
        
        lottieView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(inset)
            make.leading.equalToSuperview().inset(inset)
//            make.leading.equalToSuperview().inset(inset + mainInset)
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
