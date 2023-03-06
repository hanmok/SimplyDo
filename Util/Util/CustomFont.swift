//
//  CustomFont.swift
//  Util
//
//  Created by Mac mini on 2023/03/04.
//

import UIKit



public struct CustomFont {
//    public static let memoCellTitle = UIFont.preferredFont(forTextStyle: .title2)
    public static let memoCellTitle = UIFont.preferredFont(forTextStyle: .title3)
    public static let memoCellContents = UIFont.preferredFont(forTextStyle: .subheadline)
    
    public static let memoCellworkspaceCaption = UIFont.preferredFont(forTextStyle: .caption1)
    
    public static let barButton = UIFont.systemFont(ofSize: 16)
    
    public static let memoTitle = UIFont.preferredFont(forTextStyle: .title1)
    public static let memoContents = UIFont.preferredFont(forTextStyle: .body)
    
    public static let todoCellTitle = UIFont.systemFont(ofSize: 20, weight: .regular)
    
    public static let navigationWorkspace = UIFont.preferredFont(forTextStyle: .largeTitle)
}


extension UIFont {
    public func withTraits(traits:UIFontDescriptor.SymbolicTraits) -> UIFont {
        let descriptor = fontDescriptor.withSymbolicTraits(traits)
        return UIFont(descriptor: descriptor!, size: 0) //size 0 means keep the size as it is
    }

    public func bold() -> UIFont {
        return withTraits(traits: .traitBold)
    }

    public func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
}


/* Font Size
 Large Title
 Title 1
 Title 2
 title 3
 headline
 body
 callout
 subhead
 footnote
 caption1
 caption2
 */

