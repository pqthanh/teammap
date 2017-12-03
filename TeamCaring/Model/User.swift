//
//  User.swift
//  Folotrail
//
//  Created by Phan Quoc Thanh on 9/1/17.
//  Copyright © 2017 PQT. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

@objc(User)
class User: NSObject, NSCoding, Mappable {
    
    var currentUserId   : String?
    var currentEmail    : String?
    var token           : String?
    var nickname        : String?
    var fullname        : String?
    var tenNhom         : String?
    var mota            : String?
    var soluong         : Int?
    var avata           : String?
    
    init(userId : String, email : String, token: String, nickname: String, fullname: String, tenNhom: String?, mota: String?, soluong: Int?, avata: String?) {
        self.currentUserId  = userId
        self.currentEmail   = email
        self.token          = token
        self.nickname       = nickname
        self.fullname       = fullname
        self.tenNhom        = tenNhom
        self.mota           = mota
        self.soluong        = soluong
        self.avata          = avata
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.currentUserId = aDecoder.decodeObject(forKey: "userId") as? String
        self.currentEmail = aDecoder.decodeObject(forKey: "currentEmail") as? String
        self.token = aDecoder.decodeObject(forKey: "token") as? String
        self.nickname = aDecoder.decodeObject(forKey: "nickname") as? String
        self.fullname = aDecoder.decodeObject(forKey: "fullname") as? String
        self.tenNhom = aDecoder.decodeObject(forKey: "tenNhom") as? String
        self.mota = aDecoder.decodeObject(forKey: "mota") as? String
        self.soluong = aDecoder.decodeObject(forKey: "soluong") as? Int
        self.avata = aDecoder.decodeObject(forKey: "avata") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(currentUserId, forKey: "userId")
        aCoder.encode(currentEmail, forKey: "currentEmail")
        aCoder.encode(token, forKey: "token")
        aCoder.encode(nickname, forKey: "nickname")
        aCoder.encode(fullname, forKey: "fullname")
        aCoder.encode(tenNhom, forKey: "tenNhom")
        aCoder.encode(mota, forKey: "mota")
        aCoder.encode(soluong, forKey: "soluong")
        aCoder.encode(avata, forKey: "avata")
    }
    
    required init?(map: Map){
        super.init()
        currentUserId <- map["userId"]
        currentEmail <- map["email"]
        token <- map["authentication_token"]
    }
    
    func mapping(map: Map) {
        currentUserId <- map["userId"]
        currentEmail <- map["email"]
        token <- map["authentication_token"]
    }
}

