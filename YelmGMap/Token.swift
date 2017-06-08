//
//  Token.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import SwiftyJSON

class Token: NSObject, NSCoding
{
    let expiredIn: Date?
    let value: String?
    let type: String?
    
    enum CodingKey
    {
        static let value     = "value"
        static let type      = "type"
        static let expiredIn = "expiredIn"
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.value = aDecoder.decodeObject(forKey: CodingKey.value) as? String
        self.type  = aDecoder.decodeObject(forKey: CodingKey.type) as? String
        self.expiredIn = aDecoder.decodeObject(forKey: CodingKey.expiredIn) as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(value, forKey: CodingKey.value)
        aCoder.encode(type, forKey: CodingKey.type)
        aCoder.encode(expiredIn, forKey: CodingKey.expiredIn)
    }
    
    init(json: JSON) {
        if let expInterval = json["expires_in"].double
        {
            var expDate = Date()
            expDate.addTimeInterval(expInterval)
            expiredIn = expDate
        }
        else { expiredIn = nil }
        
        value = json["access_token"].string
        type  = json["token_type"].string
    }
}

