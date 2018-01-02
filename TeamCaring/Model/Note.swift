//
//  Note.swift
//  TeamCaring
//
//  Created by fwThanh on 12/26/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class Note: NSObject, Mappable {
    
    var appointmentId: Int?
    var general: String?
    var id: Int?
    var reminder: String?
    var separate: String?
    var time: String?
    var imageUrl: String?
    
    init(appointmentId : Int, general : String, id: Int, reminder: String, separate: String, time: String, imageUrl: String) {
        self.appointmentId      = appointmentId
        self.general            = general
        self.id                 = id
        self.reminder           = reminder
        self.separate           = separate
        self.time               = time
        self.imageUrl           = imageUrl
    }
    
    required init?(map: Map){
        super.init()
        appointmentId <- map["appointmentId"]
        general <- map["general"]
        id <- map["id"]
        reminder <- map["reminder"]
        separate <- map["separate"]
        time <- map["time"]
        imageUrl <- map["imageUrl"]
    }
    
    func mapping(map: Map) {
        appointmentId <- map["appointmentId"]
        general <- map["general"]
        id <- map["id"]
        reminder <- map["reminder"]
        separate <- map["separate"]
        time <- map["time"]
        imageUrl <- map["imageUrl"]
    }
}
