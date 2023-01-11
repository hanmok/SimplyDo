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
    
//    let memoManager = MemoManager()
    
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
        self.tabBarController?.tabBar.isHidden = false
        
        fetchMemos()
        memoTableView.rowHeight = UITableView.automaticDimension
        memoTableView.estimatedRowHeight = 20
    }
    
    private func fetchMemos() {
        memos = coreDataManager.fetchMemos()
        print("fetch memos")
        // TODO: make tableview
    }
    
    private func setupLayout() {
        addSubViews()
        setupFloatingButton()
        setupTableViewLayout()
    }
    
    private func setupTableViewLayout() {
        memoTableView.delegate = self
        memoTableView.dataSource = self
        memoTableView.snp.makeConstraints { make in
//            make.leading.trailing.equalToSuperview().inset(16)
            make.leading.trailing.equalToSuperview().inset(8)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc func addTapped() {
        let newMemoController = MemoController(coreDataManager: coreDataManager)
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
    
    private let memoTableView: UITableView = {
        let view = UITableView()
        view.register(MemoTableCell.self, forCellReuseIdentifier: MemoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
//        view.rowHeight = UITableView.automaticDimension
//        view.estimatedRowHeight = 80
        return view
    }()
    
//    private lazy var floatingAddBtn: UIButton = {
//        return self.designKit.FloatingButton(image: UIImage.plusInCircle, color: .orange)
//    }()
//    private lazy var floatingAddBtn: UIButton = {
//        let btn = UIButton()
//        btn.translatesAutoresizingMaskIntoConstraints = false
//        let imgView = UIImageView(image: UIImage.plusInCircle)
//        btn.backgroundColor = .white
//        imgView.translatesAutoresizingMaskIntoConstraints = false
//        imgView.tintColor = .orange
////        btn.layer.cornerRadius = btn.frame
//        btn.addSubview(imgView)
//        imgView.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.height.equalToSuperview()
//        }
//       return btn
//    }()
    
    private let floatingAddBtn: CircularButton = {
        let btn = CircularButton()
        let image = UIImage(systemName: "plus")!
        btn.backgroundColor = UIColor(white: 0.05, alpha: 1)
        btn.addImage(image, tintColor: .mainOrange)
        btn.layer.borderWidth = 4
        btn.layer.borderColor = UIColor.magenta.cgColor
//        btn.addShadow(offset: CGSize(width: 15, height: 10))

        return btn
    }()
}

extension MemoTabController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MemoTableCell.reuseIdentifier, for: indexPath) as! MemoTableCell
        cell.memoItem = memos[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let approximatedWidthOfBioTextView = view.frame.width - 16 - 16
        let size = CGSize(width: approximatedWidthOfBioTextView, height: 1000)

        let estimatedFrame = NSString(string: memos[indexPath.row].contents).boundingRect(with: size, options: .usesLineFragmentOrigin,attributes: [.font: UIFont.systemFont(ofSize: 20)], context: nil)
        
// title top, titleHeight, contents spacing, bottom inset, contents inset
        return estimatedFrame.height + 8 + 24 + 6 + 8 + 16
    }
}




//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.type = .moveIn
//        transition.subtype = .fromTop
//        view.window?.layer.add(transition, forKey: kCATransition)
//        newMemoController.modalPresentationStyle = .fullScreen
//        newMemoController.modalPresentationStyle = .fullScreen
//        newMemoController.modalTransitionStyle = .
//        self.navigationController?.pushViewController(newMemoController, animated: true)
//        self.present(newMemoController, animated: true)
//        newMemoController.tabBarController?.tabBar.isHidden = true
