//
//  YelpRequestRouter.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

//MARK: Helpers
fileprivate enum ParamKeys
{
    static let clientId     = "client_id"
    static let clientSecret = "client_secret"
    static let term         = "term"
    static let latitude     = "latitude"
    static let longitude    = "longitude"
    static let radius       = "radius"
}

fileprivate enum HeaderKeys
{
    static let authorization = "Authorization"
}

fileprivate enum ParamValues
{
    static let clientId = "4dhv5RSlcL7Eh61WydcjKg"
    static let clientSecret = "aNReQe9VxmHA5QlcVY6Nysf61gM87lRZWJbQgtxELWod5a1B3SAFypD1w7w9m7xo"
}

// MARK: Yelp Request Router
enum YelpRequestRouter
{
    case accessToken
    case businesess(String, radius: String)
    
    private static let baseUrlString = "https://api.yelp.com/"
    private var stateMachine: UserStateMachine {
        return UserStateMachine.shared
    }
    
    var headers: HTTPHeaders? {
        switch self
        {
        case .accessToken: return nil
            
        case .businesess:
            if let token = stateMachine.token,
                let type = token.type,
                let value = token.value
            {
                return [HeaderKeys.authorization: "\(type) \(value)"]
            }
            return nil
        }
    }
    
    private var parameters: [String: String] {
        
        let stateMachine = UserStateMachine.shared
        
        var params: [String: String] = [:]
        
        switch self
        {
        case .accessToken:
            params[ParamKeys.clientId] = ParamValues.clientId
            params[ParamKeys.clientSecret] = ParamValues.clientSecret
            
        case .businesess(let term, let radius):
            let location  = stateMachine.searchLocation
            let latitude  = location.latitude
            let longitude = location.longitude
            
            params[ParamKeys.latitude] = String(latitude)
            params[ParamKeys.longitude] = String(longitude)
            
            params[ParamKeys.radius] = radius
            params[ParamKeys.term] = term
        }
        
        return params
    }
    
    private var method: HTTPMethod {
        switch self
        {
        case .accessToken: return .post
        case .businesess: return .get
        }
    }
    
    private var relativePath: String {
        switch self
        {
        case .accessToken: return "oauth2/token"
        case .businesess: return "v3/businesses/search"
        }
    }
    
    private var urlForRequest: URL {
        var url = URL(fileURLWithPath: YelpRequestRouter.baseUrlString)
        url.appendPathComponent(relativePath)
        
        return url
    }
    
    func get(_ completion: (()->())? = nil) {
                    
        let params = parameters
        
        Alamofire.request(urlForRequest,
                          method: method,
                          parameters: params,
                          headers: headers).responseJSON { response in
                            if let data = response.data
                            {
                                let json = JSON(data: data)
                                parse(json: json)                               
                            }
        }
        
        func parse(json: JSON) {
            switch self
            {
            case .accessToken:
                let token = Token(json: json)
                self.stateMachine.save(token: token)
                completion?()
                
            case .businesess:
                let businesess = json["businesses"].arrayValue.map { businessJ in
                    return Business(json: businessJ)
                }
                
                businesess.forEach {
                    guard $0 != nil else { return }
                    self.stateMachine.businesess.append($0!)
                }
                
                NotificationCenter.default.post(name: .didRecieveBusinesess,
                                                object: nil)
            }
        }
    }
}
