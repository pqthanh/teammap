//
//  Leader.swift
//  TeamCaring
//
//  Created by PqThanh on 12/6/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Leader: NSObject, Mappable {
    var extraGroupDescription: String?
    var extraGroupName: String?
    var extraGroupTotalMember: Int?
    var fullName: String?
    var id: Int?
    var imageUrl: String?
    var members: [Member]?
    var nickname: String?
    var numberAppointments: Int?
    var pushToken: String?
    var userId: Int?
    
    init(tdescription : String, extraGroupDescription : String, extraGroupName : String, extraGroupTotalMember : Int, userId : Int, id : Int, numberAppointments : Int, nickname : String, members : [Member], pushToken: String, fullName: String, imageUrl: String)
    {
        self.pushToken                  = pushToken
        self.extraGroupDescription      = extraGroupDescription
        self.extraGroupName             = extraGroupName
        self.extraGroupTotalMember      = extraGroupTotalMember
        self.userId                     = userId
        self.id                         = id
        self.numberAppointments         = numberAppointments
        self.nickname                   = nickname
        self.members                    = members
        self.fullName                   = fullName
        self.imageUrl                   = imageUrl
    }
    
    required init?(map: Map){
        super.init()
        pushToken <- map["pushToken"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        userId <- map["userId"]
        id <- map["id"]
        numberAppointments <- map["numberAppointments"]
        nickname <- map["nickname"]
        members <- map["members"]
        fullName <- map["fullName"]
        imageUrl <- map["imageUrl"]
    }
    
    func mapping(map: Map) {
        pushToken <- map["pushToken"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        userId <- map["userId"]
        id <- map["id"]
        numberAppointments <- map["numberAppointments"]
        nickname <- map["nickname"]
        members <- map["members"]
        fullName <- map["fullName"]
        imageUrl <- map["imageUrl"]
    }
}
