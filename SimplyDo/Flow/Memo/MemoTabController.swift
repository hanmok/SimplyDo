//
//  TodoController.swift
//  SimplyDo
//
//  Created by Mac mini on 2022/12/26.
//

import UIKit
import SnapKit
import Then
import Lottie
import Util
import DesignKit
import Toast
import AVFAudio
import AVFoundation

class MemoTabController: UIViewController {
    
    let topSpacingHeight: CGFloat = 10
    let designKit = DesignKitImp()
    var memos: [Memo] = []
    var coreDataManager: CoreDataManager
    
    private func initializeMemos() {
//        self.initializeWorkspace()
        memoTableView.reloadData()
    }
    lazy var maximumContentsHeight = NSString(string: "\n\n\n\n").boundingRect(with:CGSize(width:view.frame.width - 32, height: 1000), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)], context: nil)

    
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLayoutSubviews() {
        let gradientLayer = CAGradientLayer(start: .topCenter, end: .bottomCenter, colors: [
            UIColor(white: 1.0, alpha: 1.0).cgColor,
            UIColor(white: 1.0, alpha: 0.0).cgColor
        ], type: .axial)
        gradientLayer.locations = [0.0, 1.0]
        
        gradientLayer.frame = topSpacingView.bounds
        topSpacingView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTargets()
        setupRightBarButton()
        
        setupNavigationBar()
    }
    
    
    private func setupRightBarButton() {
        let rightButton = UIButton(image: UIImage.plainCheckmark, tintColor: UIColor(white: 0.5, alpha: 0.5), hasInset: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    private func setupNavigationBar() {
        setupWorkspaceNavigationBar()
        hideNavigationBarLine()
    }
    
    private func setupWorkspaceNavigationBar() {
//        initializeWorkspace()
//        setupBiggerWorkspacePickerMenu()
        setupWorkspacePickerMenu({ workspaceTitle in
            self.fetchMemos(workspaceTitle: workspaceTitle)
        })
    }
    
    private func hideNavigationBarLine() {
        self.navigationController?.hideNavigationBarLine()
    }
    
    
    
    private func addWorkspaceAction() {
        
        let alertController = UIAlertController(title: "Add Workspace", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Workspace Name"
            textField.autocapitalizationType = .sentences
        }

        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { [weak self] alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            guard firstTextField.text! != "" else { return }
            self?.coreDataManager.createWorkspace(title: firstTextField.text!)
            self?.view.makeToast("Workspace named '\(firstTextField.text!)' has been created")
            self?.setupWorkspaceNavigationBar()
        })

        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear called, lastUsedWorkspace: \(UserDefaults.standard.lastUsedWorkspace)")
        super.viewWillAppear(animated)
        
        let lastUsedWorkspace = UserDefaults.standard.lastUsedWorkspace
        if ["none", "All"].contains(lastUsedWorkspace) == false {
            fetchMemos(workspaceTitle: UserDefaults.standard.lastUsedWorkspace)
        } else {
            fetchMemos()
        }
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func fetchMemos(workspaceTitle: String? = nil) {
        let lastUsedWorkspace = UserDefaults.standard.lastUsedWorkspace
        if ["none", "All"].contains(lastUsedWorkspace) == false {
            memos = coreDataManager.fetchMemos(workspaceTitle: lastUsedWorkspace)
        } else {
            memos = coreDataManager.fetchMemos()
        }
        memos.forEach {
            print("fetched Memo title: \($0.title)")
        }
        DispatchQueue.main.async {
            self.memoTableView.reloadData()
        }
    }
    
    private func setupLayout() {
        addSubViews()
        setupFloatingButton()
        setupTopSpacing()
        setupTableViewLayout()
        setupNavBarButton()
    }
    
   
//    private let tagButton = UIButton(image: UIImage.tag, tintColor: .mainOrange, hasInset: true, inset: 4)
    
    private func setupNavBarButton(){
        
//        let stackview = UIStackView.init(arrangedSubviews: [tagButton])
//        stackview.distribution = .equalSpacing
//        stackview.axis = .horizontal
//        stackview.alignment = .center
//        stackview.spacing = 16
        
//        let rightBarButton = UIBarButtonItem(customView: stackview)
//        self.navigationItem.rightBarButtonItem = rightBarButton
        
        
//        self.view.addSubview(workspaceButton)
//        workspaceButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().inset(22)
//            make.top.equalTo(view.snp.top).offset(50)
//        }
//
//        self.view.addSubview(triangleButton)
//        triangleButton.snp.makeConstraints { make in
//            make.leading.equalTo(workspaceButton.snp.trailing).offset(4)
//            make.width.height.equalTo(26)
//            make.centerY.equalTo(workspaceButton.snp.centerY)
//        }
        
        navTitleWorkspaceButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        // FIXME: Text Size 에 따라 크기 달라지도록 설정해야함.
        navTitleWorkspaceButton.frame = CGRect(x: 0, y: 0, width: 200, height: 60)
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: navTitleWorkspaceButton)
    }
    
    private let topSpacingView = UIView()
    
    private func setupTopSpacing() {
        view.addSubview(topSpacingView)
        topSpacingView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(self.topSpacingHeight)
        }
    }
    
    private func setupTableViewLayout() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(10)
            make.bottom.equalToSuperview().offset(-tabbarHeight)
        }
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc func addTapped() {
        navigateToMemo(memo: nil)
    }
    
    private func navigateToMemo(memo: Memo?) {
        let newMemoController = MemoController(coreDataManager: coreDataManager, memo: memo)
        self.navigationController?.pushViewController(newMemoController, animated: true)
    }
    
    
    private func addSubViews() {
        [memoTableView, floatingAddBtn].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupFloatingButton() {
        floatingAddBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(60)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
        }
    }
    
    // MARK: - UI Components
    
    private let navTitleWorkspaceButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hex6: 0xDBDBDA)
        btn.layer.cornerRadius = 10
        btn.sizeToFit()
        return btn
    }()
    
    private func setAttributedNavigationTitle(_ title: String) {
        navTitleWorkspaceButton.setAttributedTitle(NSAttributedString(string: title, attributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle), .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
    }
    
    private let memoTableView: UITableView = {
        let view = UITableView()
        view.register(MemoTableCell.self, forCellReuseIdentifier: MemoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 20
        return view
    }()
    
    private let floatingAddBtn: CircularButton = {
        let btn = CircularButton()
        let image = UIImage.plus
        btn.addImage(image, tintColor: .mainOrange)
        btn.backgroundColor = UIColor.indigo
        return btn
    }()
}

extension MemoTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableCell.reuseIdentifier, for: indexPath) as! MemoTableCell
        cell.selectedBackgroundView = UIView().then { $0.backgroundColor = .clear }
        cell.memoItem = memos[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: navigate to memo Controller
        
        memoTapped(indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let titlePadding: CGFloat = 8 + 24 + 8 + 16
        
        let targetMemo = memos[indexPath.row]
//        if memos[indexPath.row].title == "" && memos[indexPath]
        
        let approximatedWidthOfBioTextView = view.frame.width - 16 - 16
        let contentsSize = CGSize(width: approximatedWidthOfBioTextView, height: 1000)
        let titleSize = CGSize(width: approximatedWidthOfBioTextView - 100, height: 1000)
        // 16: Contents label font
        
        
        let estimatedTitleFrame = NSString(string: targetMemo.title).boundingRect(with: titleSize, options: .usesLineFragmentOrigin,attributes: [.font: CustomFont.memoCellTitle], context: nil)
        
        let estimatedContentsFrame = NSString(string: targetMemo.contents).boundingRect(with: contentsSize, options: .usesLineFragmentOrigin,attributes: [.font: CustomFont.memoCellContents], context: nil)
        
        if targetMemo.title == "" {
            let insets: CGFloat = 8 + 12 + 8
            return estimatedContentsFrame.height + insets
        } else if targetMemo.contents == "" {
            let insets: CGFloat = 8 + 8 + 8 + 20
            return estimatedTitleFrame.height + insets
        }
        
        // title top, titleHeight, contents spacing, bottom inset, contents inset, workspace margin
//        let paddings: CGFloat = 8 + 24 + 6 + 8 + 16
//        let paddings: CGFloat = 8 + 6 + 8 + 16
        
        let paddings: CGFloat = 8 + 8 + 3 + 8 + 12 + 8 // contentView
        let contentsHeight = min(estimatedContentsFrame.height, maximumContentsHeight.height)
        let titleHeight = estimatedTitleFrame.height
        return titleHeight + contentsHeight + paddings
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let memoTarget = memos.remove(at: indexPath.row)
            coreDataManager.deleteMemo(memo: memoTarget)
            memoTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.topSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 90 // bottom spacing
    }
}


extension MemoTabController: MemoTableCellDelegate {
    func memoTapped(_ cell: MemoTableCell) {
        self.navigateToMemo(memo: cell.memoItem)
    }
    
    func memoTapped(_ indexPath: IndexPath) {
        self.navigateToMemo(memo: memos[indexPath.row])
    }
}

// MARK: - Memo
/*
 Sort 기능을 넣어야함.
 생성순, or 편집순.
 항상 마지막에 생성했던 것 기준으로.
 Nope. 편집 역순만 넣기.
 */

extension MemoTabController: HasWorkspace {
    
    internal func setupWorkspacePickerMenu(_ myHandler: @escaping (String) -> ()) {

        var workspaces = ["All"]
        let fetchedWorkspaces = coreDataManager.fetchWorkspace()

        fetchedWorkspaces.forEach {
            workspaces.append($0.title)
        }
        
        let menu = UIMenu(title: "")
        
        var children = [UIMenuElement]()
        
        // make image too if has one
        workspaces.forEach { [weak self] workspaceTitle in
            children.append(UIAction(title: workspaceTitle, handler: { handler in
                self?.navTitleWorkspaceButton.setAttributedTitle(NSAttributedString(
                    string: workspaceTitle,
                    attributes:
                        [.font: CustomFont.navigationWorkspace,
                        .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]),
                                                                 for: .normal)
                UserDefaults.standard.lastUsedWorkspace = workspaceTitle
                myHandler(workspaceTitle)
            }))
        }
        
        children.append(UIAction(title: "Add", handler: { handler in
            self.addWorkspaceAction()
            print("Add tapped")
        }))
        
        let newMenu = menu.replacingChildren(children)
        self.navTitleWorkspaceButton.menu = newMenu
        self.navTitleWorkspaceButton.showsMenuAsPrimaryAction = true
        
        // set lastUsedWorkspace to navigationWorkspace Title
        let lastUsedWorkspace = UserDefaults.standard.lastUsedWorkspace ?? ""
        self.setAttributedNavigationTitle(lastUsedWorkspace)
    }
}
