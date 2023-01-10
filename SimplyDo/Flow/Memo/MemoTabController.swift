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
    
    let memoManager = MemoManager()
    let designKit = DesignKitImp()
    var memos: [Memo] = []
    
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
    }
    
    private func fetchMemos() {
        memos = memoManager.fetchMemos()
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
            make.leading.trailing.equalToSuperview().inset(16)
        }
    }
    
    private func setupTargets() {
        floatingAddBtn.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }
    
    @objc func addTapped() {
        let newMemoController = MemoController()
        self.navigationController?.pushViewController(newMemoController, animated: true)
    }
    
    private func addSubViews() {
        [floatingAddBtn, memoTableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupFloatingButton() {
        floatingAddBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(30)
            make.height.width.equalTo(50)
            make.bottom.equalToSuperview().inset(tabbarHeight + 20)
        }
    }
    
    // MARK: - UI Components
    
    private let memoTableView: UITableView = {
        let view = UITableView()
        view.register(MemoTableCell.self, forCellReuseIdentifier: MemoTableCell.reuseIdentifier)
        view.backgroundColor = .white
        view.separatorStyle = .none
        return view
    }()
    
    private lazy var floatingAddBtn: UIButton = {
        return self.designKit.FloatingButton(image: UIImage.plusInCircle, color: .orange)
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
