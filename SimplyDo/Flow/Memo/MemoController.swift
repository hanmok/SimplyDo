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
    
    init(coreDataManager: CoreDataManager, memo: Memo? = nil) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
        self.memo = memo
        print(self, #function)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self, #function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self, #function)
        setupLayout()
        setDelegates()
        addTargets()
        hideTabBar()
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.contentsTextView.becomeFirstResponder()
        }
        if memo != nil {
            self.configureLayout()
        }
    }
    
    // TODO: separate title and contents using attributed string
    private func configureLayout() {
        guard let memo = memo else { fatalError() }
        
        let attributedString = NSMutableAttributedString(string: contentsTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)])
        let attrString = NSMutableAttributedString(string: memo.title, attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .semibold)])

        attrString.append(NSAttributedString(string: "\n" + memo.contents, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        contentsTextView.attributedText = attrString
        // TODO
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(self, #function)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
        print(self,  #function)
        guard let contents = contentsTextView.text, contents != "" else { return }
        
        self.navigationController?.navigationBar.isHidden = false
    }

    private func hideTabBar() {
        UIView.animate(withDuration: 0.3) {
            self.tabBarController?.tabBar.isHidden = true
        }
    }
    
    private func addTargets() {
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentsTextView.addGestureRecognizer(scrollGesture)
    }
    
    private func save() {
        guard let contents = contentsTextView.text, contents != "" else { return }
        coreDataManager.createMemo(contents: contents)
    }
    
    private func setDelegates() {
        contentsTextView.delegate = self
    }
    
    private let contentsTextView: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.keyboardDismissMode = .onDrag
        view.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        view.addDoneButtonOnKeyboard()
        return view
    }()
    
    private func setupLayout() {
        view.backgroundColor = .white
        [contentsTextView].forEach { self.view.addSubview($0) }
        
        contentsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
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
        let length = self.contentsTextView.text.count
        contentsTextView.selectedRange = NSMakeRange(0, length)
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let attributedString = NSMutableAttributedString(string: contentsTextView.text, attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)])

        if let firstLine = textView.text.split(separator: "\n").first {
            guard let range = textView.text.range(of: firstLine) else { return }
            attributedString.addAttributes([.font: UIFont.systemFont(ofSize: 32, weight: .semibold)], range: textView.text.nsRange(from: range))
            textView.attributedText = attributedString
        }
    }
}


extension StringProtocol where Index == String.Index {
    func nsRange(from range: Range<Index>) -> NSRange {
        return NSRange(range, in: self)
    }
}
