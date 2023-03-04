//
//  TodoController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import Then
import Util
import CoreData
import Toast
import DesignKit

class TodoTabController: UIViewController {

//    let todoManager = TodoManager()
    
    var coreDataManager: CoreDataManager
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    lazy var testWorkspaces = ["All", "LifeStyle", "Work", "Personal"]
    
    var inputBoxHeight: CGFloat = 90.0
    
//    var shouldSpread = true
//    var isSpreading = false
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    let designKit = DesignKitImp()
    
    var uncheckedTodos = [Todo]()
    var checkedTodos = [Todo]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        setupNotifications()
        setupTargets()
        setupLayout()
        setupSmallerWorkspacePickerMenu()
        setupBiggerWorkspacePickerMenu()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func viewTapped() {
        hideKeyboard()
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        makeButton.addTarget(self, action: #selector(makeTapped), for: .touchUpInside)
        
        archiveButton.addTarget(self, action: #selector(archiveTapped), for: .touchUpInside)
        
//        workspaceButton.addTarget(self, action: #selector(workspaceTapped), for: .touchUpInside)
        
//         triangleButton.addTarget(self, action: #selector(workspaceTapped), for: .touchUpInside)
    }
    
    private func setupBiggerWorkspacePickerMenu() {
//        print("workSpacePicker Tapped!")

        var menu = UIMenu(title: "")
//        let some = UIMenu
//        let some = UIMenu
        
        var children = [UIMenuElement]()
        
        // make image too if has one
        testWorkspaces.forEach { workspaceName in
            children.append(UIAction(title: workspaceName, handler: { [weak self] handler in
//                print(workspaceName)
                self?.navTitleWorkspaceButton.setAttributedTitle(NSAttributedString(string: "LifeStyle", attributes: [.font: CustomFont.navigationWorkspace, .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
            }))
        }

        
        let newMenu = menu.replacingChildren(children)
        self.navTitleWorkspaceButton.menu = newMenu
        self.navTitleWorkspaceButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupSmallerWorkspacePickerMenu() {
//        print("workSpacePicker Tapped!")

        var menu = UIMenu(title: "")
        
        var children = [UIMenuElement]()
        // make image too if has one
        testWorkspaces.forEach { workspaceName in
            children.append(UIAction(title: workspaceName, handler: { handler in
//                print(workspaceName)
                self.workspacePickerButton.setTitle(workspaceName, for: .normal)
            }))
        }
        
        let newMenu = menu.replacingChildren(children)
        self.workspacePickerButton.menu = newMenu
        self.workspacePickerButton.showsMenuAsPrimaryAction = true
    }
    
    private func setupLayout() {
        addSubViews()
        setupTableViewLayout()
        setupFloatingButton()
        setupTextInputBoxView()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        
        let stackview = UIStackView.init(arrangedSubviews: [archiveButton])
        stackview.distribution = .equalSpacing
        stackview.axis = .horizontal
        stackview.alignment = .center
        stackview.spacing = 16
        
        let rightBarButton = UIBarButtonItem(customView: stackview)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        navTitleWorkspaceButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navTitleWorkspaceButton)
        
        self.navigationController?.hideNavigationBarLine()
    }
    
    private func addSubViews() {
        [todoTableView, floatingAddBtn, todoInputBoxView].forEach { self.view.addSubview($0)}
        todoTableView.layer.zPosition = 0
        floatingAddBtn.layer.zPosition = 1
        todoInputBoxView.layer.zPosition = 2
    }
    
    private func setupFloatingButton() {
        floatingAddBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(60)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
        }
    }
    
    
    
    private func setupTextInputBoxView() {

        [
            datePickerButton, workspacePickerButton,
            todoTitleTextField, makeButton].forEach { self.todoInputBoxView.addSubview($0) }
        
        todoInputBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(self.inputBoxHeight)
        }
        
        datePickerButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(6)
            make.height.equalTo(32)
            make.width.equalTo(60)
        }

        workspacePickerButton.snp.makeConstraints { make in
            make.leading.equalTo(datePickerButton.snp.trailing).offset(6)
            make.top.height.equalTo(datePickerButton)
            make.width.equalTo(100)
        }
        
        todoTitleTextField.delegate = self
        todoTitleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.equalToSuperview().inset(70)
            make.top.equalTo(datePickerButton.snp.bottom).offset(6)
            make.bottom.equalToSuperview().inset(6)
        }
        
        makeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(6)
            make.leading.equalTo(todoTitleTextField.snp.trailing).offset(6)
            make.top.bottom.equalTo(todoTitleTextField)
        }
    }
    
    private func setupTableViewLayout() {
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalToSuperview().offset(-tabbarHeight)
        }
    }
    
    // MARK: - Actions
    
    private func fetchData() {
        do {
            let allTodos = try coreDataManager.fetchTodos(predicate: TodoPredicate(completion: CompletionStatus.none))
            checkedTodos = allTodos.filter { $0.isDone == true }
            uncheckedTodos = allTodos.filter { $0.isDone == false }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
//        print(#function + "title: \(title)")
        guard title != "" else {
            self.hideKeyboard()
            return
        }
        
        do {
            let newTodo = try coreDataManager.createTodo(title: title, targetDate: targetDate)
            let firstIndexPath = IndexPath(row: 0, section: 0)
            uncheckedTodos.insert(newTodo, at: 0)
            todoTableView.performBatchUpdates {
                todoTableView.insertRows(at: [firstIndexPath], with: .top) // view
            } completion: { _ in
                self.todoTableView.reloadRows(at: [firstIndexPath], with: .automatic)
            }
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    @objc func tagTapped() {
//        print("tag Tapped")
    }
    
    @objc func archiveTapped() {
//        print("archive Tapped")
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            todoInputBoxView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight - self.inputBoxHeight)
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        todoInputBoxView.transform = CGAffineTransform(translationX: 0, y: 0)
        
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        
        todoTitleTextField.text = ""
    }
    
    @objc func makeTapped() {
//        print("makeTapped!")
        guard let title = todoTitleTextField.text else { return }
        todoInputBoxView.transform = CGAffineTransform(translationX: 0, y: 0)
        todoTitleTextField.resignFirstResponder()
        makeTodo(title: title)
        view.endEditing(true)
    }
    
    @objc func addTapped() {
        todoTitleTextField.becomeFirstResponder()
    }
    
//    @objc func workspaceTapped() {
//        print("workspaceTapped")
//        isSpreading.toggle()
//        UIView.animate(withDuration: 0.2) {
//
//            if self.isSpreading {
//                let t = CGAffineTransform(rotationAngle: -Double.pi/2)
//                self.triangleButton.transform = t
//            } else {
//                let t = CGAffineTransform(rotationAngle: 0)
//                self.triangleButton.transform = t
//            }
//        }
//    }
    
    // MARK: - UI Components
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.locale = .current
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.tintColor = .systemGreen
        return datePicker
    }()
    
    private let datePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("오늘", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = UIColor(hex6: 0xDBDBDA)
        return button
    }()
    
    
    private let workspacePickerButton: UIButton = {
        let button = UIButton()
        button.setTitle("LifeStyle", for: .normal)
        button.layer.cornerRadius = 5
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.backgroundColor = UIColor(hex6: 0xDBDBDA)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        button.sizeToFit()
        return button
    }()
    
    private let navTitleWorkspaceButton: UIButton = {
        let btn = UIButton()

        btn.setAttributedTitle(NSAttributedString(string: "LifeStyle", attributes: [.font: CustomFont.navigationWorkspace, .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
        btn.backgroundColor = UIColor(hex6: 0xDBDBDA)
//        btn.titleEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5) // 이거만 쓰면 글씨가 잘린다 ??
        btn.layer.cornerRadius = 10
        return btn
    }()
    
//    private let triangleButton: UIButton = {
//        let btn = UIButton()
//        let triangleImageView = UIImageView.leftTriangleImageView
//        btn.addSubview(triangleImageView)
//        triangleImageView.snp.makeConstraints { make in
//            make.leading.top.trailing.bottom.equalToSuperview()
//        }
//        return btn
//    }()
    
    private let calendarCell: UIButton = {
        let btn = UIButton()
        let calendarImageView = UIImageView(image: UIImage.calendar)
        btn.addSubview(calendarImageView)
        calendarImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        return btn
    }()
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.sectionHeaderTopPadding = 30.0
        view.register(UncheckedTableCell.self, forCellReuseIdentifier: UncheckedTableCell.reuseIdentifier)
        view.register(CheckedTableCell.self, forCellReuseIdentifier: CheckedTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none

        return view
    }()
    

    private let archiveButton = UIButton(image: UIImage.archiveBox, tintColor: .mainOrange, hasInset: true, inset: 0)
    
    private var makeButton: UIButton = {
        let view = UIButton(image: UIImage.paperPlane, tintColor: UIColor.mainOrange, hasInset: true)
        view.contentMode = .scaleAspectFit
        view.backgroundColor = UIColor(hex6: UIColor.indigoHex, alpha: 0.9)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    private let floatingAddBtn: CircularButton = {
        let btn = CircularButton()
        let image = UIImage.plus
        btn.addImage(image, tintColor: .mainOrange)
        btn.backgroundColor = UIColor.indigo
        return btn
    }()
    
    private lazy var todoInputBoxView: UIView = {
        return self.designKit.View(color: UIColor(white: 0.9, alpha: 1))
    }()
    
    private lazy var todoTitleTextField: UITextField = {
        let view = self.designKit.PaddedTextField()
        view.applyCornerRadius(on: .all, radius: 8.0)
        let attr = NSMutableAttributedString(string: "What are you going to do?", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)])
        view.attributedPlaceholder = attr
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        view.inputAccessoryView = nil
        return view
    }()
}

// MARK: - TableView Delegate, DataSource

extension TodoTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = makeTodoSection(using: section)
        switch section {
            case .todo:
                return uncheckedTodos.count
            case .done:
                return checkedTodos.count
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewTapped()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = makeTodoSection(using: indexPath.section)
        
        switch section {
            case .todo:
                let todoItem = uncheckedTodos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: UncheckedTableCell.reuseIdentifier, for: indexPath) as! UncheckedTableCell
                cell.todoCellDelegate = self
                cell.todoItem = todoItem
                
                let isLastCell = indexPath.row == uncheckedTodos.count - 1
//                cell.applyCornerRadius(on: isLastCell ? .bottom : .none, radius: 10)
                cell.contentView.applyCornerRadius(on: isLastCell ? .bottom : .none, radius: 10)
                return cell
                
            case .done:
                let todoItem = checkedTodos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckedTableCell.reuseIdentifier, for: indexPath) as! CheckedTableCell
                cell.todoCellDelegate = self
                cell.todoItem = todoItem
                
                let isLastCell = indexPath.row == checkedTodos.count - 1
                cell.contentView.applyCornerRadius(on: isLastCell ? .bottom : .none, radius: 10)
                
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let section = makeTodoSection(using: indexPath.section)
        if editingStyle == .delete {
            switch section {
                case .todo:
                    let deletingTodo = uncheckedTodos[indexPath.row]
                    do {
                        try coreDataManager.delete(todo: deletingTodo)
                        uncheckedTodos.remove(at: indexPath.row)
                        todoTableView.performBatchUpdates {
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        } completion: { _ in
                            tableView.reloadData()
                        }
                        self.view.makeToast("delete")
                    } catch {
                        self.view.makeToast("failed to delete todo ")
                    }
                case .done:
                    let deletingTodo = checkedTodos[indexPath.row]
                    do {
                        try coreDataManager.delete(todo: deletingTodo)
                        checkedTodos.remove(at: indexPath.row)
                        todoTableView.performBatchUpdates {
                            tableView.deleteRows(at: [indexPath], with: .automatic)
                        } completion: { _ in
                            tableView.reloadData()
                        }
                        self.view.makeToast("delete")
                    } catch {
                        self.view.makeToast("failed to delete todo ")
                    }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    // MARK: - Table Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = makeTodoSection(using: section)
        let emptyView = UIView()
        
        let view = PaddedLabel()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true
        view.backgroundColor = .indigo
        
        emptyView.addSubview(view)
        view.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
        
        if section == .todo && uncheckedTodos.count != 0 {
            view.text = "오늘 할 것"
            view.textColor = .white
            return emptyView
        } else if section == .done && checkedTodos.count != 0 {
            view.text = "완료!"
            view.textColor = .white
            return emptyView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 90
        } else {
            fatalError()
        }
    }
}


extension TodoTabController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let title = textField.text!
        makeTodo(title: title)
        textField.text = ""
        return true
    }
}

extension TodoTabController: UncheckedTableCellDelegate {
    func checkmarkTapped(_ cell: UncheckedTableCell) {
        guard let targetTodo = cell.todoItem, let targetIndexRow = uncheckedTodos.firstIndex(of: targetTodo) else { return }
        do {
            try coreDataManager.toggleDoneState(todo: targetTodo)
            let targetIndexPath = IndexPath(row: targetIndexRow, section: 0)
            uncheckedTodos.remove(at: targetIndexRow)
            checkedTodos.insert(targetTodo, at: 0)

            todoTableView.performBatchUpdates {
                let newIndexPath = IndexPath(row: 0, section: 1)
                todoTableView.moveRow(at: targetIndexPath, to: newIndexPath)
            } completion: { _ in
                self.todoTableView.reloadData()
            }
        } catch {
            self.view.makeToast("failed toggle")
        }
    }
    
    func titleTapped(_ cell: UncheckedTableCell) {
        //        guard let todoItem = cell.todoItem else { return }
        // TODO: show Up subView for editing todo
    }
}


extension TodoTabController: CheckedTableCellDelegate {
    func checkmarkTapped(_ cell: CheckedTableCell) {
        guard let targetTodo = cell.todoItem, let targetIndexRow = checkedTodos.firstIndex(of: targetTodo) else { return }
        do {
            try coreDataManager.toggleDoneState(todo: targetTodo)
            let targetIndexPath = IndexPath(row: targetIndexRow, section: 1)
            
            uncheckedTodos.insert(targetTodo, at: 0)
            checkedTodos.remove(at: targetIndexRow)
            
            todoTableView.performBatchUpdates {
                todoTableView.moveRow(at: targetIndexPath, to: IndexPath(row: 0, section: 0))
            } completion: { success in
                self.todoTableView.reloadData()
            }
        } catch {
            self.view.makeToast("failed toggle")
        }
    }
    
    func titleTapped(_ cell: CheckedTableCell) {
        
    }
}

extension TodoTabController {
    private func makeTodoSection(using section: Int) -> TodoSection {
        if (0 ... 1).contains(section) {
            return TodoSection(rawValue: section)!
        }
        fatalError()
    }
}

extension TodoTabController {
    func menu(for barButtonItem: UIBarButtonItem) -> UIMenu {
        UIMenu(title: "Some Menu", children: [UIDeferredMenuElement { [weak self, weak barButtonItem] completion in
            guard let self = self, let barButtonItem = barButtonItem else { return }
//            print("Menu shown - pause your game timers and such here")
            
            // Create your menu's real items here:
            let realMenuElements = [UIAction(title: "Some Action") { _ in
//                print("Menu action fired")
            }]
            
            // Hand your real menu elements back to the deferred menu element
            completion(realMenuElements)
            
            // Recreate the menu. This is necessary in order to get this block to
            // fire again on future taps of the bar button item.
            barButtonItem.menu = self.menu(for: barButtonItem)
        }])
    }
}
