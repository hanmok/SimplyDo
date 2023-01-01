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
    var todos = [Todo]()
    
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
            make.height.equalTo(self.todos.count * 40 + 40)
        }
    }
    
    // MARK: - Actions
    
    private func updateTodoTable() {
        do {
            todos = try todoManager.fetchTodos()
        } catch let error{
            print(error.localizedDescription)
        }
        todoTableView.reloadData()
        todoTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.todos.count * 40 + 40)
        }
    }
    
    private func makeTodo(title: String, targetDate: Date = Date()) {
        guard let title = todoTitleTextField.text, title != "" else {
            self.view.makeToast("empty string", position: .top)
            return
        }
        
        do {
            try todoManager.createTodo(title: title, targetDate: targetDate)
            updateTodoTable()
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
    
    public let makeButton: UIButton = {
        let view = UIButton()
        let imgView = UIImageView(image: UIImage.inputCompleted)
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .blue
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview().inset(10)
        }
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        return view
    }()
    
//    public var floatingAddBtn: FloatingButton = {
//        let floatingButton = FloatingButton(image: UIImage.plusInCircle)
//        return floatingButton
//    }()
    public var floatingAddBtn = DesignKitImp().floatingButton(image: UIImage.plusInCircle)
    
    public let todoInputBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    public let todoTitleTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        view.autocorrectionType = .no
        view.textColor = UIColor(white: 1, alpha: 1)
        let attr = NSMutableAttributedString(string: "Todo Title", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)])
        view.attributedPlaceholder = attr
                                                                       
                                                                       
//        view.attributedPlaceholder = NSMutableAttributedString(attributedString: NSAttributedString(string: "Todo Title", attributes: [.foregroundColor: UIColor(white: 0.9, alpha: 1)]))
        // FIXME: Need to hide some bar..
        
//        var item = view.inputAssistantItem
//        item.leadingBarButtonGroups = []
//        item.trailingBarButtonGroups = []
        
//        view.inputAccessoryView = nil
//        view.textContentType = .oneTimeCode
//        view.hi
//        view.inputView = nil
        
        return view
    }()
}

extension TodoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableCell.reuseIdentifier, for: indexPath) as! TodoTableCell
        cell.todoCellDelegate = self
        cell.todoItem = todos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try todoManager.delete(todo: todos[indexPath.row])
                self.view.makeToast("delete")
                self.updateTodoTable()
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
