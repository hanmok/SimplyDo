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

class TodoController: UIViewController {
    
    let todoManager = TodoManager()
    var todos = [Todo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchTodos()
    }
    
    
    private let todoTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = .magenta
        view.register(TodoTableCell.self, forCellReuseIdentifier: TodoTableCell.reuseIdentifier)
        return view
    }()
    
    private func fetchTodos() {
        todos = todoManager.fetchTodos()
        todoTableView.reloadData()
        todoTableView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.todos.count * 40 + 40)
        }
    }
    
    private func setupLayout() {
        
        [todoTableView].forEach { self.view.addSubview($0) }
        todoTableView.delegate = self
        todoTableView.dataSource = self
        
        todoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(self.todos.count * 40 + 40)
        }
    }
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

