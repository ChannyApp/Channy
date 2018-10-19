//
//  AppDependency.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit
import Moya
import RIBs
import AlamofireImage
import RxSwift
import Firebase
import FirebaseDatabase

class AppDependency: NSObject {
    
    let disposeBag = DisposeBag()
    
    static var shared = AppDependency()
    private var launchRouter: LaunchRouting?

    var interfaceImageDownloader: ImageDownloader = ImageDownloader()

    func startApp(with window: UIWindow) {

        self.commonSetup()
        
        let launchRouter = RootBuilder(dependency: AppComponent()).build()
        self.launchRouter = launchRouter
        launchRouter.launchFromWindow(window)
    }
    
    func commonSetup() {
        self.setupMainAppearance()
        self.setupFirebase()
        
        FirebaseManager.setup()
    }

    
    func setupMainAppearance() {
        UIBarButtonItem.appearance().tintColor = .main
    }
    
    func setupFirebase() {
        FirebaseApp.configure()
        
        Database.database().isPersistenceEnabled = true
    }
}
