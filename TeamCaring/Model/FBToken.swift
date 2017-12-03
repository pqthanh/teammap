//
//  FBToken.swift
//  TeamCaring
//
//  Created by Phan Quoc Thanh on 12/1/17.
//  Copyright © 2017 PqThanh. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class FBToken: NSObject, Mappable {
    
    var token           : String?
    var isActived       : Bool?
    
    init(token : String, isActived : Bool) {
        self.token          = token
        self.isActived       = isActived
    }
    
    required init?(map: Map){
        super.init()
        token <- map["id_token"]
        isActived <- map["activated"]
    }
    
    func mapping(map: Map) {
        token <- map["id_token"]
        isActived <- map["activated"]
    }
}
