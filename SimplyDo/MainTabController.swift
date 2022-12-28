//
//  MainTabController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit

class MainTabController: UITabBarController, UINavigationControllerDelegate {
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        setupLayouts()
        setupTargets()
        setupNotifications()
    }
    
    func configureViewControllers() {
        let todoController = TodoController()
        
        let todo = templateNavigationController(
            unselectedImage: UIImage(systemName: "checkmark.circle")!.withTintColor(.magenta),
            selectedImage: UIImage(systemName: "checkmark.circle.fill")!,
            rootViewController: TodoController())
        
        let memo = templateNavigationController(
            unselectedImage: UIImage(systemName: "bubble.right")!,
            selectedImage: UIImage(systemName: "bubble.right.fill")!,
            rootViewController: MemoController())
        
        viewControllers = [todo, memo]
    }
    
    func templateNavigationController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.navigationBar.tintColor = .magenta
        return nav
    }
    
    private func setupLayouts() {
        view.backgroundColor = .white
        self.tabBar.backgroundColor = UIColor(white: 0.85, alpha: 1.0)
        self.tabBar.unselectedItemTintColor = UIColor(white: 0.5, alpha: 1.0)
        
        self.view.addSubview(floatingAddBtn)
        NSLayoutConstraint.activate(
            [
                floatingAddBtn.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
                floatingAddBtn.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: -20),
                floatingAddBtn.heightAnchor.constraint(equalToConstant: 50),
                floatingAddBtn.widthAnchor.constraint(equalToConstant: 50)
            ])
        
        self.view.addSubview(todoInputBoxView)
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
    
    // MARK: - Actions
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        makeButton.addTarget(self, action: #selector(makeTapped), for: .touchUpInside)
    }
    
    func makeTodo(title: String = "empty", targetDate: Date = Date()) {
        print("todo with title \(title) has created")
    }
    
    @objc func makeTapped() {
        makeTodo()
        
        view.endEditing(true)
        todoInputBoxView.snp.remakeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.snp.bottom)
            make.height.equalTo(40)
        }
        textField.resignFirstResponder()
    }
    
    @objc func addTapped() {
        print("add Tapped, selectedIdx: \(selectedIndex)")
        textField.becomeFirstResponder()
    }
    
    // MARK: - Views
    
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
    
    // MARK: - Notifications
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
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
}

extension MainTabController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let title = textField.text
        makeTodo()
        textField.text = ""
        return true
    }
}
