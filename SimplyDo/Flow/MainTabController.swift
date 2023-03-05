//
//  MainTabController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import CoreData
import IQKeyboardManagerSwift

class MainTabController: UITabBarController, UINavigationControllerDelegate {
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        // Memo Tab
        if item == (self.tabBar.items!)[2]{
            IQKeyboardManager.shared.enable = true
            print("keyboardManager enabled")
            
        } else {
            IQKeyboardManager.shared.enable = false
            IQKeyboardManager.shared.enableAutoToolbar = false
        }
    }
    
    var coreDataManager = CoreDataManager()
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navigationController?.navigationBar.isHidden = true
        
        configureViewControllers()
        setupLayouts()
        selectedIndex = 1
        if selectedIndex == 2 {
            IQKeyboardManager.shared.enable = true
        }
    }
    
    func configureViewControllers() {
        
        let calendar = templateNavigationController(
            unselectedImage: UIImage.calendar.withTintColor(.magenta),
            selectedImage: UIImage.calendar,
            rootViewController: FSCalendarTabController(coreDataManager: coreDataManager))
        
        let todo = templateNavigationController(
            unselectedImage: UIImage.unchecked.withTintColor(.magenta),
            selectedImage: UIImage.checked,
            rootViewController: TodoTabController(coreDataManager: coreDataManager))
        
        let memo = templateNavigationController(
            unselectedImage: UIImage.unselectedMessageTab,
            selectedImage: UIImage.selectedMessageTab,
            rootViewController: MemoTabController(coreDataManager: coreDataManager))
        
//        let tag = templateNavigationController(
//            unselectedImage: UIImage.tag,
//            selectedImage: UIImage.tag,
//            rootViewController: TagTabController())
        
//        viewControllers = [todo, memo, tag]
        
        viewControllers = [calendar, todo, memo]
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
