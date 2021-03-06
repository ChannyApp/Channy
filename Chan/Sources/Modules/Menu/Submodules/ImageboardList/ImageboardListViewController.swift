//
//  ImageboardListViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 10/03/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

let ImageboardCellIdentifier = "ImageboardCell"

protocol ImageboardListPresentableListener: class {

    func select(idx: Int)
    func settingTapped()
}

final class ImageboardListViewController: BaseViewController, ImageboardListPresentable, ImageboardListViewControllable {
    

    weak var listener: ImageboardListPresentableListener?
    private let disposeBag = DisposeBag()
    
//    var _newDataSubject: PublishSubject<[ImageboardViewModel]> = PublishSubject()
//    var newDataSubject: PublishSubject<[ImageboardViewModel]> { return self._newDataSubject }

    
    private var data: [ImageboardViewModel] = []
    
    // UI
    @IBOutlet weak var tableView: UITableView!
    private let header = ImageboardHeader.instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    // MARK: ImageboardListPresentable
    func update(data: [ImageboardViewModel]) {
        self.data = data
        self.tableView.reloadData()
    }
    
    // MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.register(UINib(nibName: ImageboardCellIdentifier, bundle: nil), forCellReuseIdentifier: ImageboardCellIdentifier)

        
        let headerHeight: CGFloat = 60
        
        self.header.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.header)
//        self.tableView.tableHeaderView = self.header
        
        self.header.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.height.equalTo(headerHeight)
            make.top.equalToSuperview().offset(Utils.statusBarHeight)
        }
        self.tableView.rowHeight = 80
        self.tableView.delegate = self
        self.tableView.dataSource = self
      
        
        self.tableView.contentInset = UIEdgeInsets(top: headerHeight, left: 0, bottom: MenuIndicatorBottomOffset, right: 0)
        
    }
    
    private func setupRx() {
        self.header
            .settingsButton
            .rx
            .tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.listener?.settingTapped()
            })
            .disposed(by: self.disposeBag)
    }
    
    
    override func setupTheme() {
        super.setupTheme()
        
        ThemeManager.shared.append(view: ThemeView(view: self.tableView, type: .table, subtype: .none))
    }
}

extension ImageboardListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.listener?.select(idx: indexPath.row)
    }
}

extension ImageboardListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: ImageboardCellIdentifier, for: indexPath)
        
        if let cell = cell as? ImageboardCell {
            let model = self.data[indexPath.row]
            cell.update(with: model)
        }
        
        return cell
    }
    
    
}
