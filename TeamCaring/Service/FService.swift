//
//  FService.swift
//  Folotrail
//
//  Created by Phan Quoc Thanh on 9/1/17.
//  Copyright © 2017 PQT. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class FService: NSObject {
    
    static let sharedInstance = FService()
    
    func request(urlRequest: URLRequestConvertible, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        Alamofire.request(urlRequest).validate().responseJSON { (response) in
                guard response.result.isSuccess else {
                    completion(nil, response.result.error)
                    return
                }
                
                guard let value = response.result.value as? [String: Any] else {
                    completion(nil, nil)
                    return
                }
                
                completion(value["data"], nil)
        }
    }
    
    func request (url: URLConvertible, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            guard response.result.isSuccess else {
                completion(nil, response.result.error)
                return
            }
            
            guard let value = response.result.value as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(value, nil)
        }
    }
    
    func requestHttpCode (url: URLConvertible, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: Int?, _ error: Error?) -> Void) {
        
        let authHeader    = [ "content-type" : "application/json", "authorization" : "Bearer  \(Caring.userToken ?? "")" ]
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: authHeader).responseJSON { response in
            let statusCode = (response.response?.statusCode)!
            completion(statusCode, nil)
        }
    }
    
    func requestWithHeader (url: URLConvertible, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {

        let authHeader    = [ "content-type" : "application/json", "authorization" : "Bearer  \(Caring.userToken ?? "")" ]
        Alamofire.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: authHeader).responseJSON { response in
            
            let statusCode = (response.response?.statusCode)!
            print(statusCode)
            
            guard response.result.isSuccess else {
                completion(nil, response.result.error)
                return
            }
            
            guard let value = response.result.value as? [String: Any] else {
                completion(nil, nil)
                return
            }
            
            completion(value, nil)
        }
    }
    
    func loginFaceboook(token : String, completion: @escaping (_ userInfo: FBToken?) -> ()) -> () {
        
        request(url: Router.login, method: .post, params: ["pushToken": Caring.deviceToken ?? "", "socialToken" : token ]) { (result, error) in
            
            if let result = result as? [String: Any] {
                let fbInfo = Mapper<FBToken>().map(JSON: result)
                completion(fbInfo)
            }
            else {
                completion(nil)
            }
        }
        
    }
    
    func updateProfile(fullName : String, nickName: String, nameGroup: String, description: String, totalMember: Int, completion: @escaping (_ code: Int?) -> ()) -> () {
        
        let params = (nameGroup == "" && description == "") ? ["profile" : ["fullName" : fullName, "nickname" : nickName]] : ["profile" : ["fullName" : fullName, "nickname" : nickName], "anonymousGroup" : [["name" : nameGroup, "description" : description, "totalMember" : totalMember] ]]
        print(params)
        
        requestHttpCode(url: Router.updateProfile, method: .post, params: params, completion: { (result, error) in
            completion(result)
        })
        
    }
}
