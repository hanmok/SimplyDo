//
//  MemoController.swift
//  SimplyDo
//
//  Created by Mac mini on 2023/01/09.
//

import UIKit
import SnapKit

class MemoController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        setDelegates()
        addTargets()
        
        Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
            self.titleTextField.becomeFirstResponder()
        }
    }
    
    private func addTargets() {
        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(hideKeyboard))
        contentsTextView.addGestureRecognizer(scrollGesture)
    }
    
    private func setDelegates() {
        titleTextField.delegate = self
        contentsTextView.delegate = self
    }

    convenience init(memo: Memo) {
        self.init(nibName: nil, bundle: nil)
        print("conv init called")
        contentsTextView.becomeFirstResponder()
    }
    
    private let titleTextField: UITextField = {
        let view = UITextField()
        view.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    private let contentsTextView: UITextView = {
        let view = UITextView()
        view.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        return view
    }()
    
    private func setupLayout() {
        [titleTextField, contentsTextView].forEach { self.view.addSubview($0) }
        titleTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        contentsTextView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
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
}

