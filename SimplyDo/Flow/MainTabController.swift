//
//  MainTabController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import CoreData

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
            unselectedImage: UIImage.unchecked.withTintColor(.magenta),
            selectedImage: UIImage.checked,
            rootViewController: TodoTabController())
        
        let memo = templateNavigationController(
            unselectedImage: UIImage.unselectedMessageTab,
            selectedImage: UIImage.selectedMessageTab,
            rootViewController: MemoTabController())
        
        let tag = templateNavigationController(
            unselectedImage: UIImage.tag,
            selectedImage: UIImage.tag,
            rootViewController: TagTabController())
        
        viewControllers = [todo, memo, tag]
    }
    
    func templateNavigationController(unselectedImage: UIImage,
                                      selectedImage: UIImage,
                                      rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage.withTintColor(.orange, renderingMode: .alwaysOriginal)
        nav.navigationBar.tintColor = .magenta
        return nav
    }
    
    private func setupLayouts() {
        view.backgroundColor = .white
//        self.tabBar.backgroundColor = UIColor(white: 0.85, alpha: 1)
        self.tabBar.backgroundColor = UIColor(hex6: UIColor.indigoHex, alpha: 0.9)
        self.tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1)
    }
}
