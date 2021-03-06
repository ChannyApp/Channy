//
//  ProxyViewController.swift
//  Chan
//
//  Created by Mikhail Malyshev on 05/06/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import RxCocoa

protocol ProxyPresentableListener: class {
    func checkProxy() -> Observable<Bool>
    func saveProxy(title: String?)
    func deleteProxy()
    func enableProxy(enable: Bool)
}

final class ProxyViewController: UITableViewController, ProxyPresentable, ProxyViewControllable {

    weak var listener: ProxyPresentableListener?
    
    private let disposeBag = DisposeBag()
    
    
    @IBOutlet weak var serverCanvas: UITableViewCell!
    @IBOutlet weak var sportCanvas: UITableViewCell!
    @IBOutlet weak var usernameCanvas: UITableViewCell!
    @IBOutlet weak var passwordCanvas: UITableViewCell!
    @IBOutlet weak var enabledProxyCanvas: UITableViewCell!
    
    @IBOutlet weak var serverTextField: UITextField!
    @IBOutlet weak var portTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var enabledTitle: UILabel!
    @IBOutlet weak var enableSwitcher: UISwitch!
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    
    private var canvases: [UIView] {
        return [self.serverCanvas, self.sportCanvas, self.usernameCanvas, self.passwordCanvas, self.enabledProxyCanvas]
    }
    
    private var textFields: [UIView] {
        return [self.serverTextField, self.portTextField, self.usernameTextField, self.passwordTextField]
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    var buildedModel: ProxyModel? {
        if let server = self.serverTextField.text, let portString = self.portTextField.text, let port = Int(portString) {
            return ProxyModel(server: server, port: port, username: self.usernameTextField.text, password: self.passwordTextField.text)
        }
        
        return nil
    }
    
    func updateProxy(model: ProxyModel?) {
        if let model = model {
            self.serverTextField.text = model.server
            self.portTextField.text = String(model.port)
            self.usernameTextField.text = model.username
            self.passwordTextField.text = model.password
        } else {
            self.serverTextField.text = nil
            self.portTextField.text = nil
            self.usernameTextField.text = nil
            self.passwordTextField.text = nil

        }
    }

    //MARK: Private
    private func setup() {
        self.setupUI()
        self.setupRx()
    }

    private func setupUI() {
        self.setupTheme()
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = "SOCKS5 Proxy"
        
        let deleteButton = UIBarButtonItem(title: "Delete".localized, style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = deleteButton
        self.enableSwitcher.isOn = Values.shared.proxyEnabled
        
        self.enabledTitle.text = "proxy_enabled".localized
        self.checkButton.setTitle("proxy_test".localized, for: .normal)
        self.acceptButton.setTitle("proxy_apply".localized, for: .normal)
        
        self.enableSwitcher.tintColor = ThemeManager.shared.theme.accnt
        self.enableSwitcher.onTintColor = ThemeManager.shared.theme.accnt
    }

    
    private func setupRx() {
        self.checkButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self, let listener = self.listener else { return }
                self.showCentralActivity()
                 listener.checkProxy()
                .subscribe(onNext: { [weak self] result in
                    
                    self?.hideCentralActivity()
                    if result {
//                        ErrorDisplay.presentAlert(with: nil, message: "Успешно", dismiss: 0.75)
                        
                        self?.listener?.saveProxy(title: "connection_successful".localized)
                    } else {
                        ErrorDisplay.presentAlert(with: "Error".localized, message: "not_connected_proxy".localized, dismiss: 0.75)
                    }
                    
                    
                    
                }, onError: { error in
                    self.hideCentralActivity()
                    ErrorDisplay.presentAlert(with: "Error".localized, message: "not_connected_proxy".localized, dismiss: 1.5)

//                    ErrorManager.errorHandler(for: nil, error: error).show()
                })
                .disposed(by: self.disposeBag)
            }).disposed(by: self.disposeBag)
        
        self.acceptButton
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.saveProxy(title: nil)
            })
            .disposed(by: self.disposeBag)
        
        self.enableSwitcher
            .rx
            .controlEvent(.valueChanged)
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                if let value = self?.enableSwitcher.isOn {
                    self?.listener?.enableProxy(enable: value)
                }
            })
            .disposed(by: self.disposeBag)
        
        Values.shared.proxyObservable
            .asObservable()
            .subscribeOn(Helper.rxMainThread)
            .subscribe(onNext: { [weak self] model in
                self?.updateProxy(model: model)
            })
            .disposed(by: self.disposeBag)
        
        self.navigationItem
            .rightBarButtonItem?
            .rx
            .tap
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                self?.listener?.deleteProxy()
            })
            .disposed(by: self.disposeBag)
        
    }
    
    private func setupTheme() {
        let theme = ThemeManager.shared
        
        theme.append(view: ThemeView(object: self.view, type: .background, subtype: .none))
        let _ = self.canvases.map({ theme.append(view: ThemeView(object: $0, type: .cell, subtype: .none)) })
        let _ = self.textFields.map({ field in
            theme.append(view: ThemeView(object: field, type: .input, subtype: .none))
            field.backgroundColor = .clear
        })
        
        theme.append(view: ThemeView(object: self.checkButton, type: .button, subtype: .accent))
        theme.append(view: ThemeView(object: self.navigationController?.navigationBar, type: .navBar, subtype: .none))
        theme.append(view: ThemeView(object: self.enabledTitle, type: .text, subtype: .accent))
    }
}
