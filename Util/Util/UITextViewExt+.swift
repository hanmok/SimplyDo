//
//  UITextViewExt+.swift
//  Util
//
//  Created by Mac mini on 2023/01/10.
//

import Foundation
import UIKit

extension UITextView {
    public func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x:0, y:0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let bottomItem = UIBarButtonItem(image: UIImage(systemName: "chevron.down"), style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, bottomItem]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        DispatchQueue.main.async {
            self.resignFirstResponder()
        }
    }
}

protocol KeyboardDelegate {
    func saveButtonTapped()
}

extension UITextView: KeyboardDelegate {
    func saveButtonTapped() {
        
    }
}
