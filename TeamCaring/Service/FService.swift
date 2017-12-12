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
            
            guard let value = response.result.value as? [[String: Any]] else {
                completion(nil, nil)
                return
            }
            
            completion(value, nil)
        }
    }
    
    func requestAuthorized (url: URLConvertible, method: HTTPMethod, params: [String: Any]?, completion: @escaping (_ result: Any?, _ error: Error?) -> Void) {
        
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
                let userInfo = Mapper<Leader>().map(JSON: result["profile"] as! [String : Any])
                Caring.userInfo = User(userId: "\(userInfo?.id ?? 0)", email: (userInfo?.email ?? ""), token: token, nickname: (userInfo?.nickname ?? ""), fullname: (userInfo?.fullName ?? ""), tenNhom: (userInfo?.extraGroupName ?? ""), mota: (userInfo?.extraGroupDescription ?? ""), soluong: userInfo?.extraGroupTotalMember, avata: (userInfo?.imageUrl ?? ""))
                completion(fbInfo)
            }
            else {
                completion(nil)
            }
        }
    }
    
    func getCurrentProfile(completion: @escaping (_ result: Leader?) -> ()) -> () {
        requestAuthorized(url: Router.getMyProfile, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let profile = Mapper<Leader>().map(JSON: result)
                completion(profile)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func updateProfile(fullName : String, nickName: String, nameGroup: String, description: String, totalMember: Int, email: String, completion: @escaping (_ code: Int?) -> ()) -> () {
        
        let params = (nameGroup != "" && description != "") ? ["fullName" : fullName, "nickname" : nickName, "extraGroupName" : nameGroup, "extraGroupDescription" : description, "extraGroupTotalMember" : totalMember, "pushToken" : Caring.deviceToken!, "email": email] : ["fullName" : fullName, "nickname" : nickName, "pushToken" : Caring.deviceToken!, "email": email] as [String : Any]
        
        requestHttpCode(url: Router.updateProfile, method: .put, params: params, completion: { (result, error) in
            completion(result)
        })
    }
    
    func createTeam (description : String, extraGroupDescription: String, extraGroupName: String, extraGroupTotalMember: Int, iconId: Int, name: String, totalMember: Int, completion: @escaping (_ code: Int?) -> ()) -> () {
        
        var params = [String: Any]()
        if extraGroupName == "" {
            params = ["description": description,
                      "iconId": iconId,
                      "name": name,
                      "level": totalMember] as [String : Any]
        }
        else {
            params = ["description": description,
                      "extraGroupDescription": extraGroupDescription,
                      "extraGroupName": extraGroupName,
                      "extraGroupTotalMember": extraGroupTotalMember,
                      "iconId": iconId,
                      "name": name,
                      "level": totalMember] as [String : Any]
        }
        
        requestHttpCode(url: Router.creatTeam, method: .post, params: params, completion: { (result, error) in
            completion(result)
        })
    }
    
    func joinTeam (teamId: Int, leaderId: Int, completion: @escaping (_ code: Int?) -> ()) -> () {
        
        let params = ["teamId": teamId, "leaderId": leaderId] as [String : Any]
        requestHttpCode(url: Router.joinTeam, method: .post, params: params, completion: { (result, error) in
            completion(result)
        })
    }
    
    func acceptJoinTeam (requestId: Int, response: String, completion: @escaping (_ code: Int?) -> ()) -> () {
        
        let params = ["requestId": requestId, "response": response] as [String : Any]
        requestHttpCode(url: Router.acceptJoinTeam, method: .post, params: params, completion: { (result, error) in
            completion(result)
        })
    }
    
    func searchTeam (query : String, page: Int, completion: @escaping (_ result: [Team]?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.searchTeam.path.appending("?query=\(query)&page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestWithHeader(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [[String: Any]] {
                let listItems = Mapper<Team>().mapArray(JSONObject: result)
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func searchMyTeam (query : String, page: Int, completion: @escaping (_ result: [Team]?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.searchMyTeam.path.appending("?query=\(query)&page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Team>().mapArray(JSONObject: result["result"])
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func searchNewTeam (query : String, page: Int, completion: @escaping (_ result: [Team]?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.searchNewTeam.path.appending("?query=\(query)&page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Team>().mapArray(JSONObject: result["result"])
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func searchLeader (teamId: Int, query : String, page: Int, completion: @escaping (_ result: [Leader]?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.searchLeader.path.appending("\(teamId)?query=\(query)&page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Leader>().mapArray(JSONObject: result["result"])
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func getMyTeams (page: Int, completion: @escaping (_ result: [Team]?, _ totalPage: Int?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.myTeam.path.appending("?page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Team>().mapArray(JSONObject: result["result"])
                let totalPage = result["totalPages"]
                completion(listItems, totalPage as? Int)
            }
            else {
                completion(nil, nil)
            }
        })
    }
    
    func getDetailTeam (idTeam: Int, completion: @escaping (_ result: Member?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.detailTeam.path.appending("\(idTeam)")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Member>().map(JSON: result)
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
    
    func getNotification (page: Int, completion: @escaping (_ result: [Notification]?) -> ()) -> () {
        
        let path = Router.baseURLString.appending(Router.listNotification.path.appending("?page=\(page)&size=10")).replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: path)
        
        requestAuthorized(url: url!, method: .get, params: nil, completion: { (result, error) in
            if let result = result as? [String: Any] {
                let listItems = Mapper<Notification>().mapArray(JSONObject: result["result"])
                completion(listItems)
            }
            else {
                completion(nil)
            }
        })
    }
}
