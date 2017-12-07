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
    var tdescription: String?
    var extraGroupDescription: String?
    var extraGroupName: String?
    var extraGroupTotalMember: Int?
    var iconId: Int?
    var id: Int?
    var level: Int?
    var name: String?
    var totalMember: Int?
    var members: [Member]?
    
    init(tdescription : String, extraGroupDescription : String, extraGroupName : String, extraGroupTotalMember : Int, iconId : Int, id : Int, level : Int, name : String, totalMember : Int, members : [Member])
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
        self.members                    = members
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
        members <- map["members"]
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
        members <- map["members"]
    }
    
}
