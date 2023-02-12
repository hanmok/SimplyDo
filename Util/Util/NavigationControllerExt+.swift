//
//  NavigationControllerExt+.swift
//  Util
//
//  Created by Mac mini on 2023/02/12.
//

import UIKit

extension UINavigationController {
    public func hideNavigationBarLine() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
    }
}
