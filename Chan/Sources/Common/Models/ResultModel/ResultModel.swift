//
//  RequestModel.swift
//  Chan
//
//  Created by Mikhail Malyshev on 09.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import UIKit

class ResultModel<Type> {
    var result: Type
    
    init(result: Type) {
        self.result = result
    }
}
