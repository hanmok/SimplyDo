//
//  HasWorkspace.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/04/08.
//

import Foundation
import UIKit

protocol HasWorkspace: UIViewController {
    func setupWorkspacePickerMenu(_: @escaping (String) -> () )
}
