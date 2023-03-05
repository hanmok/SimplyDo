//
//  WorkspaceController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/03/05.
//

import Foundation
import UIKit

// 이게, 굳이 필요한가? Side 에서 조작하도록 하는게 더 좋을 것 같은데 ?? Order 도 바꿀 수 있으면 좋고.

class WorkspaceController: UIViewController {
    let coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
