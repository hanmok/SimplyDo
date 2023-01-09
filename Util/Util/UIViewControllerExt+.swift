//
//  UIViewControllerExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/09.
//

import UIKit

extension UIViewController {
    public var tabbarHeight: CGFloat {
        return self.tabBarController?.tabBar.frame.height ?? 83.0
    }
}
