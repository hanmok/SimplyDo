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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(type(of: self)) \(#function)")
    }
    
    var coreDataManager = CoreDataManager()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        configureViewControllers()
        setupLayouts()
        selectedIndex = 1
        
    }
    
    func configureViewControllers() {
        let todo = templateNavigationController(
            unselectedImage: UIImage.unchecked.withTintColor(.magenta),
            selectedImage: UIImage.checked,
            rootViewController: TodoTabController(coreDataManager: coreDataManager))
        
        let memo = templateNavigationController(
            unselectedImage: UIImage.unselectedMessageTab,
            selectedImage: UIImage.selectedMessageTab,
            rootViewController: MemoTabController(coreDataManager: coreDataManager))
        
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
//        nav.navigationBar.tintColor = .magenta
        return nav
    }
    
    func something() {
//        self.tabBar.isHidden = true
    }
    
    private func setupLayouts() {
//        view.backgroundColor = .magenta
        view.backgroundColor = .white
        self.tabBar.backgroundColor = UIColor(hex6: UIColor.indigoHex, alpha: 0.9)
        self.tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1)
    }
}
