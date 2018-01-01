//
//  Appointment.swift
//  TeamCaring
//
//  Created by fwThanh on 1/1/18.
//  Copyright © 2018 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Appointment: NSObject, Mappable {
    
    var user        : Member?
    var list        : [Event]?
    
    init(user : Member, list : [Event]) {
        self.user       = user
        self.list       = list
    }
    
    required init?(map: Map){
        super.init()
        user <- map["user"]
        list <- map["list"]
    }
    
    func mapping(map: Map) {
        user <- map["user"]
        list <- map["list"]
    }
}
