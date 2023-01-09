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

class MemoTabController: UIViewController {
    
    let designKit = DesignKitImp()
    
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
        let newMemoController = MemoController()
        
//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = .moveIn
//        transition.subtype = .fromTop
//        view.window?.layer.add(transition, forKey: kCATransition)
//        newMemoController.modalPresentationStyle = .fullScreen
//        newMemoController.modalPresentationStyle = .fullScreen
//        newMemoController.modalTransitionStyle = .
//        self.navigationController?.pushViewController(newMemoController, animated: true)
//        self.present(newMemoController, animated: true)
//        newMemoController.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(newMemoController, animated: true)
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
