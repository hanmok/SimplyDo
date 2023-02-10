//
//  UIImageExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/01.
//

import Foundation
import UIKit

extension UIImage {
    public static var checked: UIImage {
        return UIImage(systemName: "checkmark.circle.fill")!
    }
    
    public static var unchecked: UIImage {
        return UIImage(systemName: "checkmark.circle")!
    }
    
    public static var unselectedMessageTab: UIImage {
        return UIImage(systemName: "bubble.right")!
    }
    
    public static var selectedMessageTab: UIImage {
        return UIImage(systemName: "bubble.right.fill")!
    }
    
    public static var paperPlane: UIImage {
        return UIImage(systemName: "paperplane.fill")!
    }
    
    public static var plusInCircle: UIImage {
        return UIImage(systemName: "plus.circle")!
    }
    
    public static var plus: UIImage {
        return UIImage(systemName: "plus")!
    }
    
    public static var tag: UIImage {
        return UIImage(systemName: "number")!
    }
    
    public static var calendar: UIImage {
        return UIImage(systemName: "calendar")!
    }
}
