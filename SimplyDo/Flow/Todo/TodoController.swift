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

class TodoController: UIViewController {
    
    let todoManager = TodoManager()
    let designKit = DesignKitImp()
    
    var uncheckedTodos = [Todo]()
    var checkedTodos = [Todo]()
//    var allTodos = [Todo]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupTargets()
        setupLayout()
        setupInitialTableData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        print("viewTapped!")
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //        setupInitialTableData()
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
        setupFloatingButton()
        setupTextInputBoxView()
        setupTableViewLayout()
    }
    
    private func addSubViews() {
        //        [floatingAddBtn, todoInputBoxView, todoTableView, checkedTableView].forEach { self.view.addSubview($0)}
        [floatingAddBtn, todoInputBoxView, todoTableView].forEach { self.view.addSubview($0)}
        todoTableView.layer.zPosition = 0
        floatingAddBtn.layer.zPosition = 1
        todoInputBoxView.layer.zPosition = 2
    }
    
    private func setupFloatingButton() {
        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 83
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
        //        [todoTableView, checkedTableView].forEach { self.view.addSubview($0) }
        [self.todoTableView].forEach { self.view.addSubview($0)}
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        let numberOfTodos = (uncheckedTodos + checkedTodos).count
        todoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            //            make.height.equalTo(self.uncheckedTodos.count * 40 + 40)
            make.height.equalTo(numberOfTodos * 40 + 40)
        }
        //        checkedTableView.snp.remakeConstraints { make in
        //            make.leading.trailing.equalToSuperview().inset(16)
        //            make.top.equalTo(self.todoTableView.snp.bottom).offset(10)
        //            make.height.equalTo(self.checkedTodos.count * 40 + 40)
        //        }
    }
    
    // MARK: - Actions
    
    private func setupInitialTableData() {
        do {
            let allTodos = try todoManager.fetchTodos(predicate: FetchingPredicate(completion: CompletionStatus.none))
            checkedTodos = allTodos.filter { $0.isDone == true }
            uncheckedTodos = allTodos.filter { $0.isDone == false }
        } catch let error{
            print(error.localizedDescription)
        }
        
        todoTableView.reloadData()
        let numberOfTodos = (uncheckedTodos + checkedTodos).count
        todoTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(numberOfTodos * 40 + 40)
        }
    }
    
    private func updateTodoTable(target: [TodoSection] = [.todo, .done]) {
        
        //        todoTableView.reloadData()
        //        let allTodos = uncheckedTodos + checkedTodos
        //        if target.contains(.todo) {
        
        //            todoTableView.reloadData()
        //            todoTableView.snp.remakeConstraints { make in
        //                make.leading.trailing.equalToSuperview().inset(16)
        //                make.top.equalTo(self.view.safeAreaLayoutGuide)
        //                make.height.equalTo(allTodos.count * 40 + 40)
        //            }
        //        }
        
        //        if target.contains(.done) {
        //            checkedTableView.snp.remakeConstraints { make in
        //                make.leading.trailing.equalToSuperview().inset(16)
        //                make.top.equalTo(self.todoTableView.snp.bottom).offset(10)
        //                make.height.equalTo(self.checkedTodos.count * 40 + 40)
        //            }
        //        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
        guard title != "" else {
            self.view.makeToast("empty string", position: .top)
            return
        }
        
        do {
            let newTodo = try todoManager.createTodo(title: title, targetDate: targetDate)
            todoTableView.beginUpdates()
            let firstIndexPath = IndexPath(row: 0, section: 0)
            uncheckedTodos.insert(newTodo, at: 0)
            todoTableView.insertRows(at: [firstIndexPath], with: .top) // view
            todoTableView.endUpdates()
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
        guard let title = todoTitleTextField.text else { return }
        view.endEditing(true)
        todoInputBoxView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        todoTitleTextField.resignFirstResponder()
        
        makeTodo(title: title)
    }
    
    @objc func addTapped() {
        todoTitleTextField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.register(UncheckedTableCell.self, forCellReuseIdentifier: UncheckedTableCell.reuseIdentifier)
        view.register(CheckedTableCell.self, forCellReuseIdentifier: CheckedTableCell.reuseIdentifier)
        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return view
    }()
    
    //    private let checkedTableView: UITableView = {
    //        let view = UITableView()
    //        view.register(CheckedTableCell.self, forCellReuseIdentifier: CheckedTableCell.reuseIdentifier)
    //        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
    //        return view
    //    }()
    
    public lazy var makeButton: UIButton = {
        return self.designKit.Button(image: UIImage.inputCompleted, hasBoundary: true)
    }()
    
    public lazy var floatingAddBtn: UIButton = {
        return self.designKit.FloatingButton(image: UIImage.plusInCircle)
    }()
    
    public lazy var todoInputBoxView: UIView = {
        return self.designKit.View(color: UIColor(white: 0.9, alpha: 1))
    }()
    
    public lazy var todoTitleTextField: UITextField = {
        let view = self.designKit.PaddedTextField()
        let attr = NSMutableAttributedString(string: "Todo Title", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)])
        view.attributedPlaceholder = attr
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
}

extension TodoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        guard let section = TodoSection(rawValue: section) else { return 0 }
        //
        //        switch section {
        //            case .todo:
        //                return uncheckedTodos.count
        //            case .done:
        //                return checkedTodos.count
        //        }
        
        //        if tableView == todoTableView {
        //            print("todoTableView, section: \(section) ")
        //            return uncheckedTodos.count
        //        } else {
        //            print("checkedTableView, section: \(section)")
        //            return checkedTodos.count
        //        }
        
        guard let section = TodoSection(rawValue: section) else { return 0 }
        
        switch section {
            case .todo:
                return uncheckedTodos.count
            case .done:
                return checkedTodos.count
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = TodoSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
            case .done:
                let todoItem = checkedTodos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: CheckedTableCell.reuseIdentifier, for: indexPath) as! CheckedTableCell
                cell.todoCellDelegate = self
                cell.todoItem = todoItem
                return cell
            case .todo:
                let todoItem = uncheckedTodos[indexPath.row]
                let cell = tableView.dequeueReusableCell(withIdentifier: UncheckedTableCell.reuseIdentifier, for: indexPath) as! UncheckedTableCell
                cell.todoCellDelegate = self
                cell.todoItem = todoItem
                return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Todo" : "Done"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let section = TodoSection(rawValue: indexPath.section) else { return }
        if editingStyle == .delete {
            switch section {
                case .todo:
                    let deletingTodo = uncheckedTodos[indexPath.row]
                    do {
                        try todoManager.delete(todo: deletingTodo)
                        tableView.beginUpdates()
                        uncheckedTodos.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.endUpdates()
                        self.view.makeToast("delete")
                    } catch {
                        self.view.makeToast("failed to delete todo ")
                    }
                case .done:
                    let deletingTodo = checkedTodos[indexPath.row]
                    do {
                        try todoManager.delete(todo: deletingTodo)
                        tableView.beginUpdates()
                        checkedTodos.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        tableView.endUpdates()
                        self.view.makeToast("delete")
                    } catch {
                        self.view.makeToast("failed to delete todo ")
                    }
            }
        }
    }
}


extension TodoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let title = textField.text!
        makeTodo(title: title)
        textField.text = ""
        return true
    }
}

extension TodoController: UncheckedTableCellDelegate {
    func checkmarkTapped(_ cell: UncheckedTableCell) {
        guard let targetTodo = cell.todoItem else { return }
        guard let targetIndexRow = uncheckedTodos.firstIndex(of: targetTodo) else { return }
        let targetIndexPath = IndexPath(row: targetIndexRow, section: 0)
        uncheckedTodos.remove(at: targetIndexRow)
        checkedTodos.insert(targetTodo, at: 0)
//        todoTableView.beginUpdates()
        
//        todoTableView.insertRows(at: [targetIndexPath, newIndexPath], with: .automatic)
//        todoTableView.reloadRows(at: [targetIndexPath, newIndexPath], with: .automatic)
//        todoTableView.endUpdates()
        
//        todoTableView.performBatchUpdates {
//            <#code#>
//        }
        
        todoTableView.performBatchUpdates {
            let newIndexPath = IndexPath(row: 0, section: 1)
            todoTableView.moveRow(at: targetIndexPath, to: newIndexPath)
        } completion: { _ in
            self.todoTableView.reloadData()
        }

    }
    
    func titleTapped(_ cell: UncheckedTableCell) {
        //        guard let todoItem = cell.todoItem else { return }
        // TODO: show Up subView for editing todo
    }
}


extension TodoController: CheckedTableCellDelegate {
    func checkmarkTapped(_ cell: CheckedTableCell) {
        guard let targetTodo = cell.todoItem else { return }
        guard let targetIndexRow = checkedTodos.firstIndex(of: targetTodo) else { return }
        let targetIndexPath = IndexPath(row: targetIndexRow, section: 1)
        
        uncheckedTodos.insert(targetTodo, at: 0)
        checkedTodos.remove(at: targetIndexRow)
        
        todoTableView.performBatchUpdates {
            todoTableView.moveRow(at: targetIndexPath, to: IndexPath(row: 0, section: 0))
        } completion: { _ in
            self.todoTableView.reloadData()
        }
    }
    
    func titleTapped(_ cell: CheckedTableCell) {
        
    }
}


// reference for updating tableView
//func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//    switch type {
//          case .update:
//                 if let indexPath = indexPath {
//                 tableView.reloadRows(at: [indexPath], with: .none)
//            }
//          case .move:
//             if let indexPath = indexPath {
//                tableView.moveRow(at: indexPath, to: newIndexPath)
//              }
//         case .delete:
//              if let indexPath = indexPath {
//                 tableView.deleteRows(at: [indexPath], with: .none)
//               tableView.reloadData()    // << May be needed
//             }
//         case .insert:
//              if let newIndexPath = newIndexPath {
//                 tableView.insertRows(at: [newIndexPath], with: .none)
//                 tableView.reloadData()    // << May be needed
//              }
//         default:
//              tableView.reloadData()
//          }
//  }
