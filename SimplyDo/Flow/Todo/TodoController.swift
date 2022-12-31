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

class TodoController: UIViewController {
    
    let todoManager = TodoManager()
    var todos = [Todo]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifications()
        setupTargets()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateTodoTable()
    }
    
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
    }
    
    private func setupFloatingButton() {
        let tabbarHeight = self.tabBarController?.tabBar.frame.height ?? 83
        floatingAddBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
            make.bottom.equalToSuperview().inset(50)
        }
    }
    
    private func setupTextInputBoxView() {
        [textField, makeButton].forEach { self.todoInputBoxView.addSubview($0) }
        todoInputBoxView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        textField.delegate = self
        textField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(30)
            make.trailing.equalToSuperview().inset(60)
            make.top.bottom.equalToSuperview().inset(6)
        }
        makeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.leading.equalTo(textField.snp.trailing).offset(5)
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
        guard let title = textField.text, title != "" else {
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
        }
    }
    
    @objc func makeTapped() {
        view.endEditing(true)
        todoInputBoxView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        textField.resignFirstResponder()
        
        guard let title = textField.text else { return }
        makeTodo(title: title)
    }
    
    @objc func addTapped() {
        textField.becomeFirstResponder()
    }
    // MARK: - Views
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .magenta
        view.register(TodoTableCell.self, forCellReuseIdentifier: TodoTableCell.reuseIdentifier)
        return view
    }()
    
    public let makeButton: UIButton = {
        let view = UIButton()
        
        let imgView = UIImageView(image: UIImage(systemName: "paperplane.fill"))
        imgView.contentMode = .scaleAspectFit
        imgView.tintColor = .blue
        view.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(white: 0.3, alpha: 0.5).cgColor
        
        return view
    }()
    
    public lazy var floatingAddBtn: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        let imgView = UIImageView(image: UIImage(systemName: "plus.circle"))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.tintColor = .magenta
        
        btn.addSubview(imgView)
        imgView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalToSuperview()
        }
        return btn
    }()
    
    public let todoInputBoxView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    public let textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Input todo title"
        view.autocorrectionType = .no
        return view
    }()
}

extension TodoController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableCell.reuseIdentifier, for: indexPath) as! TodoTableCell
        cell.todoItem = todos[indexPath.row]
        return cell
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
