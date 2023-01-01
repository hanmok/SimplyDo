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

    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupTargets()
        setupLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped() {
        print("viewTapped!")
        view.endEditing(true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupInitialTableData()
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
        [floatingAddBtn, todoInputBoxView, uncheckedTableView, checkedTableView].forEach { self.view.addSubview($0)}
        uncheckedTableView.layer.zPosition = 0
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
        [uncheckedTableView, checkedTableView].forEach { self.view.addSubview($0) }
        uncheckedTableView.delegate = self
        uncheckedTableView.dataSource = self
        
        checkedTableView.delegate = self
        checkedTableView.dataSource = self
        
        uncheckedTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.uncheckedTodos.count * 40 + 40)
        }
        checkedTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.uncheckedTableView.snp.bottom).offset(10)
            make.height.equalTo(self.checkedTodos.count * 40 + 40)
        }
    }
    
    // MARK: - Actions
    
    private func setupInitialTableData() {
        do {
            uncheckedTodos = try todoManager.fetchTodos(predicate: FetchingPredicate(completion: .todo))
            checkedTodos = try todoManager.fetchTodos(predicate: FetchingPredicate(completion: .done))
        } catch let error{
            print(error.localizedDescription)
        }
        
        uncheckedTableView.reloadData()
        uncheckedTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.uncheckedTodos.count * 40 + 40)
        }
        checkedTableView.reloadData()
        checkedTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.uncheckedTableView.snp.bottom).offset(10)
            make.height.equalTo(self.checkedTodos.count * 40 + 40)
        }
        
    }
    
    private func updateTodoTable(target: [TodoSection] = [.todo, .done]) {
        
//        todoTableView.reloadData()
        if target.contains(.todo) {
            uncheckedTableView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(self.view.safeAreaLayoutGuide)
                make.height.equalTo(self.uncheckedTodos.count * 40 + 40)
            }
        }
        if target.contains(.done) {
            checkedTableView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(16)
                make.top.equalTo(self.uncheckedTableView.snp.bottom).offset(10)
                make.height.equalTo(self.checkedTodos.count * 40 + 40)
            }
        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
        guard title != "" else {
            self.view.makeToast("empty string", position: .top)
            return
        }
        
        do {
            let newTodo = try todoManager.createTodo(title: title, targetDate: targetDate)
            uncheckedTableView.beginUpdates()
            uncheckedTodos.insert(newTodo, at: 0)
            let firstIndexPath = IndexPath(row: 0, section: 0)
            uncheckedTableView.insertRows(at: [firstIndexPath], with: .top)
            updateTodoTable(target: [.todo])
            uncheckedTableView.endUpdates()
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
    
    private let uncheckedTableView: UITableView = {
        let view = UITableView()
        view.register(UncheckedTableCell.self, forCellReuseIdentifier: UncheckedTableCell.reuseIdentifier)
        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return view
    }()
    
    private let checkedTableView: UITableView = {
        let view = UITableView()
        view.register(CheckedTableCell.self, forCellReuseIdentifier: CheckedTableCell.reuseIdentifier)
        view.backgroundColor = UIColor(white: 0.5, alpha: 1)
        return view
    }()
    
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
        if tableView == uncheckedTableView {
            return uncheckedTodos.count
        } else {
            return checkedTodos.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == uncheckedTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: UncheckedTableCell.reuseIdentifier, for: indexPath) as! UncheckedTableCell
            cell.todoCellDelegate = self
            cell.todoItem = uncheckedTodos[indexPath.row]
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CheckedTableCell.reuseIdentifier, for: indexPath) as! CheckedTableCell
            cell.todoCellDelegate = self
            cell.todoItem = checkedTodos[indexPath.row]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var deletingTodo: Todo
            
            let isDeletingUnchecked = tableView == uncheckedTableView
            deletingTodo = isDeletingUnchecked ? uncheckedTodos[indexPath.row] : checkedTodos[indexPath.row]
            
            do {
                try todoManager.delete(todo: deletingTodo)
                if isDeletingUnchecked {
                    uncheckedTodos.remove(at: indexPath.row)
                } else {
                    checkedTodos.remove(at: indexPath.row)
                }
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTodoTable(target: isDeletingUnchecked ? [.todo] : [.done])
                self.view.makeToast("delete")
            } catch {
                self.view.makeToast("failed to delete todo ")
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
        print("checkmark Tapped!")
        guard let todoItem = cell.todoItem else { return }
        do {
            try todoManager.toggleDoneState(todo: todoItem)
            
            updateTodoTable()
        } catch {
            self.view.makeToast("failed to toggle done state")
        }
    }
    
    func titleTapped(_ cell: UncheckedTableCell) {
//        guard let todoItem = cell.todoItem else { return }
        // TODO: show Up subView for editing todo
    }
}


extension TodoController: CheckedTableCellDelegate {
    func checkmarkTapped(_ cell: CheckedTableCell) {
        print("checkmark tapped!")
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
