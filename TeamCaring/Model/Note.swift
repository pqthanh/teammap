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
    
    init(appointmentId : Int, general : String, id: Int, reminder: String, separate: String) {
        self.appointmentId      = appointmentId
        self.general            = general
        self.id                 = id
        self.reminder           = reminder
        self.separate           = separate
    }
    
    required init?(map: Map){
        super.init()
        appointmentId <- map["appointmentId"]
        general <- map["general"]
        id <- map["id"]
        reminder <- map["reminder"]
        separate <- map["separate"]
    }
    
    func mapping(map: Map) {
        appointmentId <- map["appointmentId"]
        general <- map["general"]
        id <- map["id"]
        reminder <- map["reminder"]
        separate <- map["separate"]
    }
}
