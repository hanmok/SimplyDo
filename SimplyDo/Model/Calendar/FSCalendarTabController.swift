//
//  CalendarController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/02/10.
//

import Util
import UIKit
import SnapKit
import FSCalendar

class FSCalendarTabController: UIViewController {
    
    private var calendarView: FSCalendar = {
        let fs = FSCalendar()
        return fs
    }()
    
    var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        self.calendarView = FSCalendar()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarLayout()
        view.backgroundColor = .clear
    }
    
    private func setCellLayout() {
        calendarView.appearance.titleWeekendColor = .red
        calendarView.appearance.titleSelectionColor = UIColor(hex6: UIColor.orangeHex, alpha: 0.85)
        calendarView.appearance.titleOffset = CGPoint(x: 0, y: -15) // 각 날짜 위치
        calendarView.appearance.titleFont = UIFont.systemFont(ofSize: 16) // 날짜 폰트
        calendarView.appearance.borderRadius = 0.4 // 0: rectangle, 1: circle
        calendarView.rowHeight = 10
    }
    
    private func setHeaderLayout() {
        calendarView.headerHeight = 100
        calendarView.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24) // 2023년 02월
        calendarView.appearance.headerTitleOffset = CGPoint(x: -90, y: 0)
        calendarView.appearance.headerTitleAlignment = .left
        calendarView.appearance.headerDateFormat = "YYYY년 MM월"
        calendarView.appearance.headerMinimumDissolvedAlpha = 0.0 // 전달, 다음 달 안보이게 설정.
    }
    
    func setupCalendarLayout() {
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.register(CustomFSCalendarCell.self, forCellReuseIdentifier: CustomFSCalendarCell.reuseIdentifier)
        
        setHeaderLayout()
        setCellLayout()
    
        calendarView.scope = .month
        calendarView.weekdayHeight = 20

        calendarView.locale = Locale(identifier: "ko_KR")

//        calendarView.allowsMultipleSelection = true
        calendarView.allowsSelection = true
        calendarView.swipeToChooseGesture.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(calendarView)
        calendarView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(calendarView.snp.width).multipliedBy(1.5)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: CustomFSCalendarCell.reuseIdentifier, for: date, at: position) as! CustomFSCalendarCell
        
//        print("current date: \(Date())")
//        if date.get(.day) == Date().get(.day) {
//            print("special day is .. \(date)")
//        }
        
//        cell.contents = ["hello", "nice to meet you"]
        
//        print("dequeuing date: \(date)")
        
        return cell
    }
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        calendar.snp.updateConstraints { make in
//            make.height.equalTo(40)
//        }
//        self.view.layoutIfNeeded()
//    }
}
