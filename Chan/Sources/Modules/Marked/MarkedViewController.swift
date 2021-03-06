//
//  MarkedViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/05/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa


protocol MarkedPresentableListener: class {
    func open(idx: Int)
    func refresh()
    
    func viewLoaded()
    func loadNext()
    
    var hasMore: Bool { get }
    
    func delete(uid: String)
    func deleteAll()
}

final class MarkedViewController: BaseViewController, MarkedPresentable, MarkedViewControllable {

    weak var listener: MarkedPresentableListener?
    
    var component: MarkedComponent? = nil
    
    var models: [ThreadModel] = []
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    private let pullToRefreshLabel = UILabel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        
        self.listener?.viewLoaded()
    }
    
    func update(with threads: [ThreadModel]) {
        self.pullToRefreshLabel.isHidden = threads.count != 0
        self.models = threads
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    func scrollToTop() {
        if self.viewDidLoaded {
            self.tableView.setContentOffset(.zero, animated: true)
        }
    }
    
    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }
    
    private func setupUI() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.backgroundColor = .clear
        
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = self.refreshControl
        } else {
            self.tableView.addSubview(self.refreshControl)
        }
        
        if let component = self.component {
            switch component.type {
            case .favorited:
                self.navigationItem.title = "Favorites".localized
            case .history:
                self.navigationItem.title = "History".localized
            }
        }
        
        
        let deleteButton = UIBarButtonItem(title: "Delete".localized, style: UIBarButtonItem.Style.done, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = deleteButton

        deleteButton
            .rx
            .tap
            .flatMap ({ _ -> Observable<Bool> in
                let err = ChanError.error(title: "delete_full_list".localized, description: "are_you_sure".localized)
                let manager = ErrorDisplay(error: err, buttons: [ErrorButton.ok, ErrorButton.cancel])
                manager.show()
                return manager.actions.asObservable().map({ button -> Bool in
                    if button == ErrorButton.ok {
                        return true
                    } else {
                        return false
                    }
                })
            })
            .asObservable()
            .subscribe(onNext: { [weak self] delete in
                if delete {
                    self?.listener?.deleteAll()
                }
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.disposeBag)
        
        self.view.addSubview(self.pullToRefreshLabel)
        self.pullToRefreshLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(48)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        self.pullToRefreshLabel.text = "pull_to_refresh".localized
        self.pullToRefreshLabel.textAlignment = .center
        self.pullToRefreshLabel.font = .tinySmallText
        self.pullToRefreshLabel.numberOfLines = 0
        ThemeManager.shared.append(view: ThemeView(view: self.pullToRefreshLabel, type: .text, subtype: .third))
    }
    
    private func setupRx() {
        self.refreshControl
            .rx
            .controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.listener?.refresh()
            })
            .disposed(by: self.disposeBag)

    }
}

extension MarkedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.listener?.open(idx: indexPath.row)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.models.count - 1 && self.listener?.hasMore ?? true {
            self.listener?.loadNext()
        }
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            let board = self.boards[indexPath.row]
////            self.listener?.viewActions.on(.next(.delete(uid: board.uid)))
////        }
//    }
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
////            if self.canAction {
//            return [UITableViewRowAction(style: .destructive, title: "Удалить", handler: { [weak self] (action, idexPath) in
//
//                if let item = self?.models[indexPath.row] {
//                    self?.listener?.delete(uid: item.id)
////                        self?.listener?.viewActions.on(.next(.delete(uid: item.id)))
//                }
//            })]
////            } else {
////                return nil
////            }
//    }
//
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }


}

extension MarkedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.models.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "MarkedCell", for: indexPath)
        
        if let c = cell as? MarkedCell {
            c.update(with: self.models[indexPath.row])
            c.delegate = self
        }
        
//        cell.textLabel?.text = self.models[indexPath.row].subject
        
        return cell
    }
    
    
    
}


extension MarkedViewController: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
//        let bgColor = ThemeManager.shared.theme.background
        
        if orientation == .left {
            
//            self.listener?.viewActions.on(.next(.openHome))
            
            
            return nil
        }
        
        let delete = SwipeAction(style: .destructive, title: "Delete".localized) { [weak self] (action, indexPath) in
            guard let self = self else { return }
            let item = self.models[indexPath.row]
            self.listener?.delete(uid: item.id)
            
            
        }
        delete.textColor = ThemeManager.shared.theme.text
//        delete.tintColor = ThemeManager.shared.theme.text
//        delete.backgroundColor = ThemeManager.shared.theme.background
//        delete.
        
        return [delete]
        
    }
    
}
