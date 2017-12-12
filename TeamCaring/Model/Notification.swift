//
//  Notification.swift
//  TeamCaring
//
//  Created by PqThanh on 12/8/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Notification: NSObject, Mappable {
    
    var customUserId: Int?
    var id: Int?
    var message: String?
    var targetId: Int?
    var read: Bool?
    var title: String?
    var type: Int?
    
    init(customUserId : Int, id : Int, message : String, targetId : Int, read : Bool, title : String, type : Int)
    {
        self.customUserId   = customUserId
        self.id             = id
        self.message        = message
        self.targetId       = targetId
        self.read           = read
        self.title          = title
        self.type           = type
    }
    
    required init?(map: Map){
        super.init()
        customUserId <- map["customUserId"]
        id <- map["id"]
        message <- map["message"]
        targetId <- map["targetId"]
        read <- map["read"]
        title <- map["title"]
        type <- map["type"]
    }
    
    func mapping(map: Map) {
        customUserId <- map["customUserId"]
        id <- map["id"]
        message <- map["message"]
        targetId <- map["targetId"]
        read <- map["read"]
        title <- map["title"]
        type <- map["type"]
    }
    
}
