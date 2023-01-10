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
    }
    
    private func setupLayout() {
        addSubViews()
        setupTableViewLayout()
        setupFloatingButton()
        setupTextInputBoxView()
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
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
        }
    }
    
    private func setupTextInputBoxView() {
        [todoTitleTextField, makeButton].forEach { self.todoInputBoxView.addSubview($0) }
        todoInputBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        todoTitleTextField.delegate = self
        todoTitleTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(60)
            make.top.bottom.equalToSuperview().inset(6)
        }
        makeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(todoTitleTextField.snp.trailing).offset(5)
            make.top.bottom.equalToSuperview().inset(6)
        }
    }
    
    private func setupTableViewLayout() {
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview().offset(-tabbarHeight)
        }
    }
    
    // MARK: - Actions
    
    private func fetchData() {
        do {
            let allTodos = try coreDataManager.fetchTodos(predicate: TodoPredicate(completion: CompletionStatus.none))
            checkedTodos = allTodos.filter { $0.isDone == true }
            uncheckedTodos = allTodos.filter { $0.isDone == false }
            Todo.printNames(todos: checkedTodos, message: "checkedTodos: ")
            Todo.printNames(todos: uncheckedTodos, message: "uncheckedTodos: ")

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
        print(#function + "title: \(title)")
        guard title != "" else {
            self.view.makeToast("empty string", position: .top)
            return
        }
        
        do {
            let newTodo = try coreDataManager.createTodo(title: title, targetDate: targetDate)
            let firstIndexPath = IndexPath(row: 0, section: 0)
            uncheckedTodos.insert(newTodo, at: 0)
            todoTableView.performBatchUpdates {
                todoTableView.insertRows(at: [firstIndexPath], with: .top) // view
            } completion: { _ in
//                self.todoTableView.reloadData()
                self.todoTableView.reloadRows(at: [firstIndexPath], with: .automatic)
            }
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            todoInputBoxView.snp.remakeConstraints { make in
                make.bottom.equalToSuperview().offset(-keyboardHeight)
                make.leading.trailing.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        todoInputBoxView.snp.remakeConstraints { make in
            make.top.equalTo(self.view.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        todoTitleTextField.text = ""
    }
    
    @objc func makeTapped() {
        print("makeTapped!")
        guard let title = todoTitleTextField.text else { return }
        todoInputBoxView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        todoTitleTextField.resignFirstResponder()
        makeTodo(title: title)
        view.endEditing(true)
    }
    
    @objc func addTapped() {
        todoTitleTextField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.sectionHeaderTopPadding = 30.0
        view.register(UncheckedTableCell.self, forCellReuseIdentifier: UncheckedTableCell.reuseIdentifier)
        view.register(CheckedTableCell.self, forCellReuseIdentifier: CheckedTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()
    
    private var makeButton: UIButton = {
        let view = UIButton(image: UIImage.inputCompleted, tintColor: UIColor.mainOrange, hasInset: true)
        return view
    }()
    
    private lazy var floatingAddBtn: UIButton = {
        return self.designKit.FloatingButton(image: UIImage.plusInCircle, color: .orange)
    }()
    
    private lazy var todoInputBoxView: UIView = {
        return self.designKit.View(color: UIColor(white: 0.9, alpha: 1))
    }()
    
    private lazy var todoTitleTextField: UITextField = {
        let view = self.designKit.PaddedTextField()
        view.applyCornerRadius(on: .all, radius: 8.0)
        let attr = NSMutableAttributedString(string: "Todo Title", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)])
        view.attributedPlaceholder = attr
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
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
                cell.applyCornerRadius(on: isLastCell ? .bottom : .none, radius: 10)
                
                return cell
                
            case .done:
                let todoItem = checkedTodos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckedTableCell.reuseIdentifier, for: indexPath) as! CheckedTableCell
                cell.todoCellDelegate = self
                cell.todoItem = todoItem
                
                let isLastCell = indexPath.row == checkedTodos.count - 1
                cell.applyCornerRadius(on: isLastCell ? .bottom : .none, radius: 10)
                
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
        
        let view = PaddedLabel()
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.backgroundColor = UIColor(white: 0.2, alpha: 1)
        view.clipsToBounds = true
        view.backgroundColor = .indigo
        
        if section == .todo && uncheckedTodos.count != 0{
            view.text = "오늘 할 것"
            view.textColor = .white
            return view
        } else if section == .done && checkedTodos.count != 0 {
            view.text = "완료!"
            view.textColor = .white
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
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
