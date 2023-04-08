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
    var originalTitle: String?
    var originalContents: String?
    
    let titleFont = CustomFont.memoTitle
    let contentsFont = CustomFont.memoContents
    var keyboardHeight: CGFloat?
    lazy var workspaces = [String]()

    var selectedWorkspace: String?
    
    
    // MARK: - Life Cycle
    init(coreDataManager: CoreDataManager, memo: Memo? = nil) {
        self.coreDataManager = coreDataManager
        self.memo = memo
        self.originalTitle = memo?.title
        self.originalContents = memo?.contents
        super.init(nibName: nil, bundle: nil)
        self.selectedWorkspace = memo?.workspace?.title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        save()
        
        stopTimer()
        
        if let contents = contentsTextView.text, contents == "", let memo = memo {
            coreDataManager.deleteMemo(memo: memo)
        }
        if let memo = memo, let originalTitle = originalTitle, let originalContents = originalContents {
            if memo.title != originalTitle || memo.contents != originalContents {
                coreDataManager.renewUpdatedDate(memo: memo)
            }
        }

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
        
        if memo == nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.contentsTextView.becomeFirstResponder()
            }
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
        
        setupRightNavigationBar()
        setupLeftNavigationBar()
    }
    
    private func setupLeftNavigationBar() {
        let backButton = UIButton(image: UIImage.left, tintColor: .orange, hasInset: false)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage.left.withTintColor(.mainOrange, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(dismissTapped))
//        backButton.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
    }
    
    @objc func dismissTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func setupRightNavigationBar() {
        self.workspaces = []
        let fetchedWorkspaces = coreDataManager.fetchWorkspace()
        
        fetchedWorkspaces.forEach {
            self.workspaces.append($0.title)
        }
        
        let menu = UIMenu(title: "")
        var children = [UIMenuElement]()
        
        workspaces.forEach { workspaceName in
            children.append(UIAction(title: workspaceName, handler: { [weak self] handler in
                self?.barButtonItem.setAttributedTitle(NSAttributedString(string: workspaceName, attributes: [.font: CustomFont.barButton, .foregroundColor: UIColor(white: 0.1, alpha: 0.9)]), for: .normal)
                self?.selectedWorkspace = workspaceName
            }))
        }
        
        let rightBarButton = UIBarButtonItem(customView: barButtonItem)
        let newMenu = menu.replacingChildren(children)
        
        barButtonItem.menu = newMenu
        barButtonItem.showsMenuAsPrimaryAction = true
        
        if selectedWorkspace == nil {
            selectedWorkspace = UserDefaults.standard.lastUsedWorkspace != .all ? UserDefaults.standard.lastUsedWorkspace : "Default"
        }
        
        self.barButtonItem.setAttributedTitle(NSAttributedString(string: selectedWorkspace!, attributes: [.font: CustomFont.barButton, .foregroundColor: UIColor(white: 0.1, alpha: 0.9)]), for: .normal)
        // FIXME: Text Size 에 따라 크기 달라지도록 설정해야함.
        barButtonItem.frame = CGRect(x: 0, y: 0, width: 110, height: 40)
        
        var copyButton = UIButton(image: UIImage.copy, tintColor: UIColor.mainOrange, hasInset: true)
        copyButton.addTarget(self, action: #selector(copyTapped), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [copyButton, barButtonItem])
        stackView.spacing = 10
        stackView.axis = .horizontal
//        self.navigationItem.rightBarButtonItem = rightBarButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: stackView)
    }
    
    @objc func copyTapped() {
        if let memo = memo {
            UIPasteboard.general.string = memo.title + "\n" + memo.contents
            self.view.makeToast("복사되었습니다", position: .top)
        }
    }
    
    // TODO: separate title and contents using attributed string
    private func configureLayout() {
        guard let memo = memo else { return }
        
        let attrString = NSMutableAttributedString(string: memo.title, attributes: [.font: titleFont])

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
//        let scrollGesture = UIPanGestureRecognizer(target: self, action: #selector(hideKeyboard))
//        contentsTextView.addGestureRecognizer(scrollGesture)
    }

    // 1초마다, Memo 화면에서 벗어날 때 호출
    private func save() {
        guard let contents = contentsTextView.text, contents != "" else { return }
        if let validMemo = memo {
            updateMemo(contents: contents, memo: validMemo)
            guard let selectedWorkspace = selectedWorkspace else { return }
            updateWorkspace(memo: validMemo, workspaceTitle: selectedWorkspace)
        } else {
            memo = makeMemo(contents: contents)
            guard let selectedWorkspace = selectedWorkspace else { return }
            updateWorkspace(memo: memo!, workspaceTitle: selectedWorkspace)
        }
    }
    
    private func updateWorkspace(memo: Memo, workspaceTitle: String) {
        coreDataManager.updateMemoWorkspace(memo: memo, workspaceTitle)
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
        btn.backgroundColor = UIColor(hex6: 0xDBDBDA)
        btn.layer.cornerRadius = 10
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return btn
    }()
    
    private lazy var contentsTextView: UITextView = {
        let view = UITextView()
        view.autocorrectionType = .no
        view.keyboardDismissMode = .onDrag
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
        let attributedString = NSMutableAttributedString(string: contentsTextView.text, attributes: [.font: contentsFont])

        if let firstLine = textView.text.split(separator: "\n").first {
            guard let range = textView.text.range(of: firstLine) else { return }
            attributedString.addAttributes([.font: titleFont], range: textView.text.nsRange(from: range))
            textView.attributedText = attributedString
        }
    }
}
