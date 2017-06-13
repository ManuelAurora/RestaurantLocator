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
    static let limit        = "limit"
}

fileprivate enum HeaderKeys
{
    static let authorization = "Authorization"
}

fileprivate enum ParamValues
{
    static let clientId = "4dhv5RSlcL7Eh61WydcjKg"
    static let clientSecret = "aNReQe9VxmHA5QlcVY6Nysf61gM87lRZWJbQgtxELWod5a1B3SAFypD1w7w9m7xo"
    static let limit = "50"
}

//GET /v3/businesses/{id}/reviews
// MARK: Yelp Request Router
enum YelpRequestRouter
{
    case accessToken
    case businesess(String, radius: String)
    case reviews(String)
    
    private static let baseUrlString = "https://api.yelp.com/"
    private var stateMachine: UserStateMachine {
        return UserStateMachine.shared
    }
    
    var headers: HTTPHeaders? {
        switch self
        {
        case .accessToken: return nil
            
        case .businesess, .reviews:
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
            params[ParamKeys.limit] = ParamValues.limit
            params[ParamKeys.radius] = radius
            params[ParamKeys.term] = term
            
        case .reviews:
            break
        }
        
        return params
    }
    
    private var method: HTTPMethod {
        switch self
        {
        case .accessToken: return .post
        case .businesess, .reviews: return .get
        }
    }
    
    private var relativePath: String {
        switch self
        {
        case .accessToken: return "oauth2/token"
        case .businesess: return "v3/businesses/search"
        case .reviews(let id): return "v3/businesses/\(id)/reviews"
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
                
                businesess.forEach { business in
                    guard business != nil else { return }
                    
                    let isAlreadyHave = stateMachine.businesess.contains { bus in
                        
                        if bus.devInfo.id == business!.devInfo.id
                        {
                            bus.isOnMap = true
                            return true
                        }
                        return false
                    }
                    
                    if !isAlreadyHave
                    {
                        stateMachine.businesess.append(business!)
                    }
                }
                NotificationCenter.default.post(name: .didRecieveBusinesess,
                                                object: nil)
                
            case .reviews:
                let reviews = json["reviews"].arrayValue.map { reviewJ in
                    return Review(json: reviewJ)
                }
                
                stateMachine.reviews = reviews
                NotificationCenter.default.post(name: .didRecieveReviews,
                                                object: nil)
                print(reviews)
            }
        }
    }
}

