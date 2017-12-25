//
//  Event.swift
//  TeamCaring
//
//  Created by fwThanh on 12/25/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Event: NSObject, Mappable {
    
    var eDescription: String?
    var id: Int?
    var name: String?
    var repeatType: String?
    var teamId: Int?
    var time: String?
    var userId: Int?
    var imageUrl: String?
    
    init(id : Int, eDescription : String, name: String, repeatType: String, teamId: Int, time: String, userId: Int, imageUrl: String) {
        self.id             = id
        self.eDescription   = eDescription
        self.repeatType     = repeatType
        self.teamId         = teamId
        self.time           = time
        self.userId         = userId
        self.name           = name
        self.imageUrl       = imageUrl
    }
    
    required init?(map: Map){
        super.init()
        id <- map["id"]
        eDescription <- map["description"]
        repeatType <- map["repeatType"]
        teamId <- map["teamId"]
        time <- map["time"]
        userId <- map["userId"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        eDescription <- map["description"]
        repeatType <- map["repeatType"]
        teamId <- map["teamId"]
        time <- map["time"]
        userId <- map["userId"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
    }
}
