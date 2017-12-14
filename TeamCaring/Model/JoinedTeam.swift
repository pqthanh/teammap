//
//  JoinedTeam.swift
//  TeamCaring
//
//  Created by PqThanh on 12/13/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class JoinedTeam: NSObject, Mappable {
    
    var id           : Int?
    var level       : Int?
    
    init(id : Int, level : Int) {
        self.id          = id
        self.level       = level
    }
    
    required init?(map: Map){
        super.init()
        id <- map["id"]
        level <- map["level"]
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        level <- map["level"]
    }
}
