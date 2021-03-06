//
//  MenuInteractor.swift
//  Chan
//
//  Created by Mikhail Malyshev on 24/02/2019.
//  Copyright © 2019 Mikhail Malyshev. All rights reserved.
//

import RIBs
import RxSwift

protocol MenuRouting: ViewableRouting {
    func setupViews()
    func openBoardSelection()

    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MenuPresentable: Presentable {
    var listener: MenuPresentableListener? { get set }

    func openBoards()

}

protocol MenuListener: class {
    func closeMenu()
}

final class MenuInteractor: PresentableInteractor<MenuPresentable>, MenuInteractable, MenuPresentableListener {

    

    weak var router: MenuRouting?
    weak var listener: MenuListener?
    
    

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: MenuPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        
        self.router?.setupViews()
        // TODO: Implement business logic here.
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // BoardListListener
    func open(board: BoardModel) {
        self.listener?.closeMenu()
    }
    
    func closeBoardsList() {
        
    }
    
    func openBoardSelection() {
        self.router?.openBoardSelection()
    }
    
    // MARK: ImageboardListListener
    func newImageboardSelected() {
        self.presenter.openBoards()
//        self.router?.openBoards()
    }
}
