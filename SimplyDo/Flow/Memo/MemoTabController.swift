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
    
    let designKit = DesignKitImp()
    var memos: [Memo] = []
    var coreDataManager: CoreDataManager
    
    init(coreDataManager: CoreDataManager) {
        self.coreDataManager = coreDataManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupTargets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self, #function)
//        self.navigationController?.navigationBar.isHidden = true
        
        fetchMemos()
        memoTableView.rowHeight = UITableView.automaticDimension
        memoTableView.estimatedRowHeight = 20
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func fetchMemos() {
        memos = coreDataManager.fetchMemos()
        print("fetch memos")
        DispatchQueue.main.async {
            self.memoTableView.reloadData()
        }
    }
    
    private func setupLayout() {
        addSubViews()
        setupFloatingButton()
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
        
        
        self.view.addSubview(workspaceButton)
        workspaceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(22)
            make.top.equalTo(view.snp.top).offset(50)
        }
        
        self.view.addSubview(triangleButton)
        triangleButton.snp.makeConstraints { make in
            make.leading.equalTo(workspaceButton.snp.trailing).offset(4)
            make.width.height.equalTo(26)
            make.centerY.equalTo(workspaceButton.snp.centerY)
        }
    }
    
    private func setupTableViewLayout() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide).offset(30)
            make.bottom.equalToSuperview().offset(-tabbarHeight)
        }
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
//        tagButton.addTarget(self, action: #selector(tagTapped), for: .touchUpInside)
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
    
    
    private let workspaceButton: UIButton = {
        let btn = UIButton()
        btn.setAttributedTitle(NSAttributedString(string: "LifeStyle", attributes: [.font: UIFont.systemFont(ofSize: 30, weight: .semibold), .foregroundColor: UIColor(white: 0.1, alpha: 0.8)]), for: .normal)
        return btn
    }()
    
    private let triangleButton: UIButton = {
        let btn = UIButton()
        let triangleImageView = UIImageView.leftTriangleImageView
        btn.addSubview(triangleImageView)
        triangleImageView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        return btn
    }()
    
    private let memoTableView: UITableView = {
        let view = UITableView()
        view.register(MemoTableCell.self, forCellReuseIdentifier: MemoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
//        view.selectedColor
        return view
    }()
    
    private let floatingAddBtn: CircularButton = {
        let btn = CircularButton()
        let image = UIImage(systemName: "plus")!
//        btn.backgroundColor = UIColor(white: 0.05, alpha: 1)
        btn.addImage(image, tintColor: .mainOrange)
//        btn.layer.borderWidth = 4
//        btn.layer.borderColor = UIColor.magenta.cgColor
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

        let estimatedFrame = NSString(string: memos[indexPath.row].contents).boundingRect(with: size, options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 20)], context: nil)

        // title top, titleHeight, contents spacing, bottom inset, contents inset
        let paddings: CGFloat = 8 + 24 + 6 + 8 + 16

        return estimatedFrame.height + paddings
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let memoTarget = memos.remove(at: indexPath.row)
            coreDataManager.deleteMemo(memo: memoTarget)
            memoTableView.deleteRows(at: [indexPath], with: .automatic)
        }
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
