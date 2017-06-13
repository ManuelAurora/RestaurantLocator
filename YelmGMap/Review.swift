//
//  Review.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 13.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import SwiftyJSON
//
//"rating": 5,
//"user": {
//    "image_url": "https://s3-media3.fl.yelpcdn.com/photo/iwoAD12zkONZxJ94ChAaMg/o.jpg",
//    "name": "Ella A."
//},
//"text": "Went back again to this place since the last time i visited the bay area 5 months ago, and nothing has changed. Still the sketchy Mission, Still the cashier...",
//"time_created": "2016-08-29 00:41:13",
//"url": "https://www.yelp.com/biz/la-palma-mexicatessen-san-francisco?hrid=hp8hAJ-AnlpqxCCu7kyCWA&adjust_creative=0sidDfo

struct Review
{
    let rating: Int
    let userName: String
    let userImageUrl: String?
    let reviewText: String
    let timeCreated: String
    let url: String
    
    init(json: JSON) {        
        rating       = json["rating"].intValue
        userName     = json["user"]["name"].stringValue
        userImageUrl = json["user"]["image_url"].string
        reviewText   = json["text"].stringValue
        timeCreated  = json["time_created"].stringValue
        url          = json["url"].stringValue
    }
}
