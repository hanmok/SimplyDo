//
//  UIImageExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/01.
//

import Foundation
import UIKit

extension UIImage {
    public static var checkedImage: UIImage {
        return UIImage(systemName: "checkmark.circle.fill")!
    }
    
    public static var uncheckedImage: UIImage {
        return UIImage(systemName: "checkmark.circle")!
    }
    
    public static var unselectedMessageImage: UIImage {
        return UIImage(systemName: "bubble.right")!
    }
    
    public static var selectedMessageImage: UIImage {
        return UIImage(systemName: "bubble.right.fill")!
    }
    
}
