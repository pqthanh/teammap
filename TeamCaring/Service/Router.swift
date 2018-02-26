//
//  Router.swift
//  Folotrail
//
//  Created by Phan Quoc Thanh on 9/1/17.
//  Copyright © 2017 PQT. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

public enum Router: URLConvertible {
    
    static let baseURLString = "https://app.trituetoanhao.org:8443/teammap/api"

    //Store authenication token
    static var OAuthToken: String?
    
    case login
    case updateProfile
    case creatTeam
    case searchTeam
    case searchMyTeam
    case searchNewTeam
    case myTeam
    case getMyProfile
    case searchLeader
    case searchMember
    case joinTeam
    case detailTeam
    case listNotification
    case acceptJoinTeam
    case updateLevelMem
    case createAppointment
    case getAppointments
    case createNote
    case updateNote
    case appointment_response
    case member_appointments
    
    //MARK: request method
    /*
    var method: HTTPMethod {
        switch self {
        case .login,
             .forgot:
            return .post
        case .logout:
            return .delete
        case .countries,
             .cities,
             .itineraries,
             .groupAll:
            return .get
        }
    }
    */
    //MARK: API name and parameter if has
    
    var path: String {
        
        switch self {
        case .login:
            return "/authenticate/facebook"
        case .updateProfile:
            return "/update-profile"
        case .creatTeam:
            return "/create-team"
        case .myTeam:
            return "/my-team"
        case .searchTeam:
            return "/_search/team"
        case .searchNewTeam:
            return "/_search/new-team"
        case .searchMyTeam:
            return "/_search/my-team"
        case .getMyProfile:
            return "/get-profile"
        case .searchLeader:
            return "/_search/leaders/"
        case .searchMember:
            return "/_search/members/"
        case .joinTeam:
            return "/join-team"
        case .detailTeam:
            return "/team/detail/"
        case .listNotification:
            return "/my-notifications"
        case .acceptJoinTeam:
            return "/join-team/response"
        case .updateLevelMem:
            return "/update-level/member"
        case .createAppointment:
            return "/create-appointment"
        case .getAppointments:
            return "/my-appointments"
        case .createNote:
            return "/create-notes"
        case .updateNote:
            return "/update-notes"
        case .appointment_response:
            return "/create-appointment/response"
        case .member_appointments:
            return "/member-appointments"
            
        }
    }
    
    public func asURL() throws -> URL {
        let url = try Router.baseURLString.asURL().appendingPathComponent(path)
        return url
    }

    /*
    //MARK: URLRequestConvertible
    public func asURLRequest() throws -> URLRequest {

        let url = try Router.baseURLString.asURL()
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        if let token = Router.OAuthToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case .login(let parameters),
             .forgot(let parameters):
            urlRequest.httpBody = try! JSONSerialization.data(withJSONObject: parameters)
        case .myContent(_ , _ ):
            urlRequest =  try JSONEncoding.default.encode(urlRequest, with: nil)
        }
        
        return urlRequest
    }
    */
}



