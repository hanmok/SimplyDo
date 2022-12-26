//
//  MainTabController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit

class MainTabController: UITabBarController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        setupLayouts()
        setupTargets()
    }
    
    private func setupLayouts() {
        view.backgroundColor = .white
        self.tabBar.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        self.tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1.0)
        
        self.view.addSubview(floatingAddBtn)
        floatingAddBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        floatingAddBtn.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 15).isActive = true
        floatingAddBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        floatingAddBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc func addTapped() {
        print("add Tapped, selectedIdx: \(selectedIndex)")
    }
    
    // MARK: - Views
    public lazy var floatingAddBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: UIImage(systemName: "plus.circle"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = .magenta
        
        btn.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return btn
    }()
    
    func configureViewControllers() {
        let todoController = TodoController()
        
        let todo = templateNavigationController(
            unselectedImage: UIImage(systemName: "checkmark.circle")!.withTintColor(.magenta),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")!,
            rootViewController: TodoController())
        
        let memo = templateNavigationController(
            unselectedImage: UIImage(systemName: "bubble.right")!,
            selectedImage: UIImage(systemName: "bubble.right.fill")!,
            rootViewController: MemoController())

        viewControllers = [todo, memo]
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .magenta
        return nav
    }
}
