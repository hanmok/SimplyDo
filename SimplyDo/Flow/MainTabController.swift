//
//  MainTabController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import CoreData
//import Model

class MainTabController: UITabBarController, UINavigationControllerDelegate {
    
    var todoManager = TodoManager()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        setupLayouts()
    }
    
    func configureViewControllers() {
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
    
    private func setupLayouts() {
        view.backgroundColor = .white
        self.tabBar.backgroundColor = UIColor(white: 0.85, alpha: 0.5)
        self.tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 0.85)
    }
}
