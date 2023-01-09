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
import Util
import DesignKit
import Toast

class MemoController: UIViewController {
    
    let designKit = DesignKitImp()
    
    //    var tabbarHeight: CGFloat {
    //        return self.tabBarController?.tabBar.frame.height ?? 83.0
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTargets()
    }
    
    private func setupLayout() {
        addSubViews()
        setupFloatingButton()
    }
    
    private lazy var floatingAddBtn: UIButton = {
        return self.designKit.FloatingButton(image: UIImage.plusInCircle, color: .orange)
    }()
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc func addTapped() {
        
    }
    
    private func addSubViews() {
        [floatingAddBtn].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupFloatingButton() {
        floatingAddBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
        }
    }
}
