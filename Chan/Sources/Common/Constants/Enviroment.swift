//
//  Enviroment.swift
//  Chan
//
//  Created by Mikhail Malyshev on 08.09.2018.
//  Copyright © 2018 Mikhail Malyshev. All rights reserved.
//

import Foundation

class Enviroment {
  
  static var `default` = Enviroment()
  
  var baseUrl: URL {
    return URL(string: "https://2ch.hk")!
  }

}

