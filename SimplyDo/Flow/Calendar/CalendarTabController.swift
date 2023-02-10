//
//  CalendarController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/02/10.
//


import UIKit
import SnapKit

class CalendarTabController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
