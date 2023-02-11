//
//  CalendarController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/02/10.
//


import UIKit
import SnapKit
import FSCalendar

class FSCalendarTabController: UIViewController {
    
    private var calendarView: FSCalendar = {
        let fs = FSCalendar()
        return fs
    }()
    var coreDataManager: CoreDataManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarLayout()
    }
    
    func setupCalendarLayout() {
        
        calendarView.delegate = self
        calendarView.dataSource = self
        
        // register
        calendarView.register(CustomFSCalendarCell.self, forCellReuseIdentifier: CustomFSCalendarCell.reuseIdentifier)
        
        
        calendarView.scope = .month // or .week
        calendarView.weekdayHeight = 20
//        calenderview
//        calendarView.scope = .week
        calendarView.locale = Locale(identifier: "ko_KR")
//        calendarView.scrollDirection = .horizontal // .vertical
        
        calendarView.headerHeight = 45
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        calendarView.appearance.headerTitleOffset = CGPoint(x: -90, y: 0)
        calendarView.appearance.headerTitleAlignment = .left
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 전달, 다음 달 안보이게 설정.
        
        calendarView.appearance.titleOffset = CGPoint(x: 0, y: -30) // 날짜 위치
        calendarView.rowHeight = 40
        
        calendarView.appearance.borderRadius = 0.4 // 0: rectangle, 1: circle
        calendarView.allowsMultipleSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
        calendarView.allowsSelection = true
        
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 20)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
//            make.bottom.equalToSuperview()
            make.bottom.equalToSuperview().inset(200)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        // calendarView Layout 에 따라 row size 가 변함
    }
    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.calendarView = FSCalendar()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FSCalendarTabController: FSCalendarDelegate, FSCalendarDataSource {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print(string + "selected")
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY"
        let string = formatter.string(from: date)
        print(string + "deselected")
    }
    
//    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
//        return "contents\ndarling"
//    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CustomFSCalendarCell.reuseIdentifier, for: date, at: position) as! CustomFSCalendarCell
        cell.contents = ["hello", "nice to meet you"]
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { make in
            make.height.equalTo(40)
        }
        self.view.layoutIfNeeded()
    }
}
