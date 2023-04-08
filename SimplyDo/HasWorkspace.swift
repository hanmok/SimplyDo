//
//  HasWorkspace.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/04/08.
//

import UIKit

protocol HasWorkspace: UIViewController {
    func setupWorkspacePickerMenu(_: @escaping (String) -> () )
}

//class VCWithWorkspace: UIViewController, HasWorkspace {
//    func setupWorkspacePickerMenu(_: @escaping (String) -> ()) {
//        <#code#>
//    }
//
//    var coreDataManager: CoreDataManager
//    init(coreDataManager: CoreDataManager) {
//        self.coreDataManager = coreDataManager
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
