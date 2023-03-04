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

class MemoTabController: UIViewController {
    
    let topSpacingHeight: CGFloat = 10
    let designKit = DesignKitImp()
    var memos: [Memo] = []
    var coreDataManager: CoreDataManager
    
    lazy var maximumContentsHeight = NSString(string: "\n\n\n\n").boundingRect(with:CGSize(width:view.frame.width - 32, height: 1000), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.preferredFont(forTextStyle: .footnote)], context: nil)
                                                                               
    lazy var testWorkspaces = ["All", "LifeStyle", "Work", "Personal"]
    
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
        // 이건 아님.
//        let rightButton = UIBarButtonItem(image: UIImage.plainCheckmark, style: .done, target: self, action: #selector(checkmarkTapped))
//        self.navigationItem.rightBarButtonItem = rightButton

        let rightButton = UIButton(image: UIImage.plainCheckmark, tintColor: UIColor(white: 0.5, alpha: 0.5), hasInset: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func checkmarkTapped() {
        
    }
    
    private func setupNavigationBar() {
        setupBiggerWorkspacePickerMenu()
        hideNavigationBarLine()
    }
    
    private func hideNavigationBarLine() {
        self.navigationController?.hideNavigationBarLine()
    }
    
    
    private func setupBiggerWorkspacePickerMenu() {
//        print("workSpacePicker Tapped!")

        let menu = UIMenu(title: "")
        
        var children = [UIMenuElement]()
        
        // make image too if has one
        testWorkspaces.forEach { [weak self] workspaceName in
            children.append(UIAction(title: workspaceName, handler: { handler in
                self?.navTitleWorkspaceButton.setAttributedTitle(NSAttributedString(string: workspaceName, attributes: [.font: CustomFont.navigationWorkspace, .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
            }))
        }

        let newMenu = menu.replacingChildren(children)
        self.navTitleWorkspaceButton.menu = newMenu
        self.navTitleWorkspaceButton.showsMenuAsPrimaryAction = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        print(self, #function)
//        self.navigationController?.navigationBar.isHidden = true
        
        fetchMemos()
        memoTableView.rowHeight = UITableView.automaticDimension
        memoTableView.estimatedRowHeight = 20
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func fetchMemos() {
        memos = coreDataManager.fetchMemos()
//        print("fetch memos")
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
    
//    @objc func tagTapped() {
//        print("tag Tapped")
//    }
    
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
            btn.setAttributedTitle(NSAttributedString(string: "LifeStyle", attributes: [.font: UIFont.preferredFont(forTextStyle: .largeTitle), .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
        btn.backgroundColor = UIColor(hex6: 0xDBDBDA)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    private let memoTableView: UITableView = {
        let view = UITableView()
        view.register(MemoTableCell.self, forCellReuseIdentifier: MemoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()
    
    private let floatingAddBtn: CircularButton = {
        let btn = CircularButton()
        let image = UIImage(systemName: "plus")!
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
        
        if memos[indexPath.row].contents == "" {
            return titlePadding
        }
        
        let approximatedWidthOfBioTextView = view.frame.width - 16 - 16
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)

        // 16: Contents label font

        let estimatedFrame = NSString(string: memos[indexPath.row].contents).boundingRect(with: size, options: .usesLineFragmentOrigin,attributes: [.font: CustomFont.memoCellContents], context: nil)
        
        // title top, titleHeight, contents spacing, bottom inset, contents inset
        let paddings: CGFloat = 8 + 24 + 6 + 8 + 16
        let contentsHeight = min(estimatedFrame.height, maximumContentsHeight.height)

        return contentsHeight + paddings
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
