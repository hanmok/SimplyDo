//
//  TodoController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import Then
import Lottie

class MemoController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(lottieView)
        lottieView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        lottieView.play()
    }
    
    private let lottieView = LottieAnimationView(name: "check").then {
        $0.loopMode = .loop
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .magenta
    }
}

