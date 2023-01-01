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
        updateTodoTable()
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
        [floatingAddBtn, todoInputBoxView, todoTableView].forEach { self.view.addSubview($0)}
        todoTableView.layer.zPosition = 0
        todoInputBoxView.layer.zPosition = 1
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
        [todoTableView].forEach { self.view.addSubview($0) }
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        todoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.uncheckedTodos.count * 30 + 40)
        }
    }
    
    // MARK: - Actions
    
    private func updateTodoTable() {
        do {
            uncheckedTodos = try todoManager.fetchTodos()
        } catch let error{
            print(error.localizedDescription)
        }
        todoTableView.reloadData()
        todoTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.uncheckedTodos.count * 40 + 40)
        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
        guard let title = todoTitleTextField.text, title != "" else {
            self.view.makeToast("empty string", position: .top)
            return
        }
        
        do {
            let newTodo = try todoManager.createTodo(title: title, targetDate: targetDate)
//            updateTodoTable()
            
            todoTableView.beginUpdates()
            uncheckedTodos.append(newTodo)
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
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            todoInputBoxView.snp.remakeConstraints { make in
                make.top.equalTo(self.view.snp.bottom)
                make.leading.trailing.equalToSuperview()
            }
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            todoTitleTextField.text = ""
        }
    }
    
    @objc func makeTapped() {
        view.endEditing(true)
        todoInputBoxView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        todoTitleTextField.resignFirstResponder()
        
        guard let title = todoTitleTextField.text else { return }
        makeTodo(title: title)
    }
    
    @objc func addTapped() {
        todoTitleTextField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.register(TodoTableCell.self, forCellReuseIdentifier: TodoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        return view
    }()
    
    
    public lazy var makeButton: UIButton = {
        return self.designKit.SedingRequestButton(image: UIImage.inputCompleted)
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
        return uncheckedTodos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableCell.reuseIdentifier, for: indexPath) as! TodoTableCell
        cell.todoCellDelegate = self
        cell.todoItem = uncheckedTodos[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try todoManager.delete(todo: uncheckedTodos[indexPath.row])
                uncheckedTodos.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
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

extension TodoController: TodoTableCellDelegate {
    func checkmarkTapped(_ cell: TodoTableCell) {
        guard let todoItem = cell.todoItem else { return }
        do {
            try todoManager.toggleDoneState(todo: todoItem)
            updateTodoTable()
        } catch {
            self.view.makeToast("failed to toggle done state")
        }
    }
    
    func titleTapped(_ cell: TodoTableCell) {
        guard let todoItem = cell.todoItem else { return }
        // TODO: show Up subView for editing todo
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
