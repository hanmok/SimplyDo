//
//  MemoController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/09.
//

import Util
import UIKit
import SnapKit
import CoreData

class MemoController: UIViewController {
    
    var coreDataManager: CoreDataManager
    var memo: Memo?
    var timer: Timer?
    
    let titleFont: UIFont = UIFont.preferredFont(forTextStyle: .title1)
    let contentsFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    
    lazy var testWorkspaces = ["All", "LifeStyle", "Work", "Personal"]
    
//    var selectedWorkspace: String = ""
    
    // MARK: - Life Cycle
    init(coreDataManager: CoreDataManager, memo: Memo? = nil) {
        self.coreDataManager = coreDataManager
        self.memo = memo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
        stopTimer()
        guard let contents = contentsTextView.text, contents != "" else { return }
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setDelegates()
        addTargets()
        hideTabBar()
        configureLayout()
        
        startSavingMemoTimer()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.contentsTextView.becomeFirstResponder()
        }
    }
    
    private func setDelegates() {
        contentsTextView.delegate = self
    }
    
    private func setupLayout() {
        view.backgroundColor = .white
        [contentsTextView].forEach { self.view.addSubview($0) }
        
        contentsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        let menu = UIMenu(title: "")
        var children = [UIMenuElement]()
        testWorkspaces.forEach { workspaceName in
            children.append(UIAction(title: workspaceName, handler: { [weak self] handler in
                self?.barButtonItem.setAttributedTitle(NSAttributedString(string: workspaceName, attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor(white: 0.1, alpha: 0.9)]), for: .normal)
            }))
        }
        
        let rightBarButton = UIBarButtonItem(customView: barButtonItem)
        let newMenu = menu.replacingChildren(children)
        
        barButtonItem.menu = newMenu
        barButtonItem.showsMenuAsPrimaryAction = true
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    
    
    // TODO: separate title and contents using attributed string
    private func configureLayout() {
        guard let memo = memo else { return }
        
//        let attrString = NSMutableAttributedString(string: memo.title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .semibold)])
        let attrString = NSMutableAttributedString(string: memo.title, attributes: [.font: titleFont])

//        attrString.append(NSAttributedString(string: "\n" + memo.contents, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        attrString.append(NSAttributedString(string: "\n" + memo.contents, attributes: [.font: contentsFont]))
        
        contentsTextView.attributedText = attrString
    }
    
    private func hideTabBar() {
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func startSavingMemoTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { timer in
            self.save()
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func addTargets() {
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentsTextView.addGestureRecognizer(scrollGesture)
    }
    
    private func save() {
        guard let contents = contentsTextView.text, contents != "" else { return }
        if let memo = memo {
            updateMemo(contents: contents,memo: memo)
        } else {
            memo = makeMemo(contents: contents)
        }
    }
    
    private func updateMemo(contents: String, memo: Memo) {
        coreDataManager.updateMemo(contents: contents, memo: memo)
    }
    
    @discardableResult
    private func makeMemo(contents: String) -> Memo? {
        return coreDataManager.createMemo(contents: contents)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - UI Properties
    
    private let barButtonItem: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "LifeStyle", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor(white: 0.1, alpha: 0.9)]), for: .normal)
        btn.backgroundColor = UIColor(hex6: 0xDBDBDA)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return btn
    }()
    
    private lazy var contentsTextView: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.keyboardDismissMode = .onDrag
//        view.font = UIFont.preferredFont(forTextStyle: .footnote)
        view.font = contentsFont
        view.addDoneButtonOnKeyboard()
        return view
    }()
    
}

// MARK: - For Title

extension MemoController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        contentsTextView.becomeFirstResponder()
    }
}

extension MemoController: UITextViewDelegate {
    func textViewDidEndEditing(_ textView: UITextView) {
        hideKeyboard()
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
//        let attributedString = NSMutableAttributedString(string: contentsTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)])
        let attributedString = NSMutableAttributedString(string: contentsTextView.text, attributes: [.font: contentsFont])

        if let firstLine = textView.text.split(separator: "\n").first {
            guard let range = textView.text.range(of: firstLine) else { return }
            attributedString.addAttributes([.font: titleFont], range: textView.text.nsRange(from: range))
            textView.attributedText = attributedString
        }
    }
}

