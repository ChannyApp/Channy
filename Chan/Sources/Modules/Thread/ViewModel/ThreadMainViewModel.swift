//
//  PostMainViewModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 19.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ThreadMainViewModel: NSObject {

    let title: String
    let canRefresh: Bool
    
    let thread: ThreadModel?
    let favorited: Bool
    
    init(title: String, canRefresh: Bool) {
        self.title = TextStripper.fullClean(text: title)
        self.canRefresh = canRefresh
        self.thread = nil
        self.favorited = false
        super.init()
    }
    
    init(thread: ThreadModel?, canRefresh: Bool) {
        self.canRefresh = canRefresh
        self.thread = thread
        if let thread = thread {
            self.title = TextStripper.fullClean(text: thread.subject)
        } else {
            self.title = ""
        }
        
        self.favorited = thread?.type == .favorited
        
        super.init()
    }
    
}
