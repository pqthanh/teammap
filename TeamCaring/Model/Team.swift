//
//  Team.swift
//  TeamCaring
//
//  Created by PqThanh on 12/5/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Team: NSObject, Mappable {
    
    var tdescription: String?
    var extraGroupDescription: String?
    var extraGroupName: String?
    var extraGroupTotalMember: Int?
    var iconId: Int?
    var id: Int?
    var level: Int?
    var name: String?
    var totalMember: Int?
    var nickname: String?
    var pushToken: String?
    var memberLevel: Int?
    var numberAppointments: Int?
    var userId: Int?
    var teamLevel: Int?
    
    init(tdescription : String, extraGroupDescription : String, extraGroupName : String, extraGroupTotalMember : Int, iconId : Int, id : Int, level : Int, name : String, totalMember : Int, nickname: String, pushToken: String, memberLevel: Int, numberAppointments: Int, userId: Int, teamLevel: Int)
    {
        self.tdescription               = tdescription
        self.extraGroupDescription      = extraGroupDescription
        self.extraGroupName             = extraGroupName
        self.extraGroupTotalMember      = extraGroupTotalMember
        self.iconId                     = iconId
        self.id                         = id
        self.level                      = level
        self.name                       = name
        self.totalMember                = totalMember
        self.nickname                   = nickname
        self.pushToken                  = pushToken
        self.memberLevel                = memberLevel
        self.numberAppointments         = numberAppointments
        self.userId                     = userId
        self.teamLevel                  = teamLevel
    }
    
    required init?(map: Map){
        super.init()
        tdescription <- map["description"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        iconId <- map["iconId"]
        id <- map["id"]
        level <- map["level"]
        name <- map["name"]
        totalMember <- map["totalMember"]
        nickname <- map["nickname"]
        pushToken <- map["pushToken"]
        memberLevel <- map["memberLevel"]
        numberAppointments <- map["numberAppointments"]
        userId <- map["userId"]
        teamLevel <- map["teamLevel"]
    }
    
    func mapping(map: Map) {
        tdescription <- map["description"]
        extraGroupDescription <- map["extraGroupDescription"]
        extraGroupName <- map["extraGroupName"]
        extraGroupTotalMember <- map["extraGroupTotalMember"]
        iconId <- map["iconId"]
        id <- map["id"]
        level <- map["level"]
        name <- map["name"]
        totalMember <- map["totalMember"]
        nickname <- map["nickname"]
        pushToken <- map["pushToken"]
        memberLevel <- map["memberLevel"]
        numberAppointments <- map["numberAppointments"]
        userId <- map["userId"]
        teamLevel <- map["teamLevel"]
    }

}
