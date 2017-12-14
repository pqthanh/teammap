//
//  Member.swift
//  TeamCaring
//
//  Created by PqThanh on 12/6/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Member: NSObject, Mappable {

    var email: String?
    var extraGroupDescription: String?
    var extraGroupName: String?
    var extraGroupTotalMember: Int?
    var fullName: String?
    var id: Int?
    var imageUrl: String?
    var nickname: String?
    var numberAppointments: Int?
    var pushToken: String?
    var level: JoinedTeam?
    var userId: Int?
    var members: [Member]?
    
    init(email : String,
         extraGroupDescription : String,
         extraGroupName : String,
         extraGroupTotalMember : Int,
         fullName : String,
         id : Int,
         imageUrl : String,
         nickname : String,
         numberAppointments : Int,
         pushToken : String,
         level: JoinedTeam,
         userId : Int,
         members : [Member])
    {
        self.email                      = email
        self.extraGroupDescription      = extraGroupDescription
        self.extraGroupName             = extraGroupName
        self.extraGroupTotalMember      = extraGroupTotalMember
        self.fullName                   = fullName
        self.id                         = id
        self.imageUrl                   = imageUrl
        self.nickname                   = nickname
        self.numberAppointments         = numberAppointments
        self.pushToken                  = pushToken
        self.level                      = level
        self.userId                     = userId
        self.members                    = members
    }
    
    required init?(map: Map){
        super.init()
        email <- map["email"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        fullName <- map["fullName"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        nickname <- map["nickname"]
        numberAppointments <- map["numberAppointments"]
        pushToken <- map["pushToken"]
        level <- map["joinedTeam"]
        userId <- map["userId"]
        members <- map["members"]
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        fullName <- map["fullName"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        nickname <- map["nickname"]
        numberAppointments <- map["numberAppointments"]
        pushToken <- map["pushToken"]
        level <- map["joinedTeam"]
        userId <- map["userId"]
        members <- map["members"]
    }
    
}
