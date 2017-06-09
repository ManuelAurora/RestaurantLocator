//
//  Business.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import SwiftyJSON

//MARK: Helpers
struct Category
{
    let title: String
    let alias: String
}

struct Location
{
    let city: String
    let zipCode: String
    let country: String
    let address: String
    let state: String
}

struct Coordinate
{
    let latitude: Double
    let longitude: Double
}

struct DevInfo
{
    let id: String
    let isClosed: Bool
    var businessCategories: [Category] = []
    let phone: String
    let imageUrl: String
    let url: String
    let coordinate: Coordinate
}

struct InfoToDisplay
{
    let rating: Int
    let displayPhone: String
    let price: String
    let name: String
    let reviewCount: Int
    let location: Location
}

//MARK: Business model
struct Business
{
    let devInfo: DevInfo
    let displayInfo: InfoToDisplay
    
    init?(json: JSON) {
        guard let id        = json["id"].string,
            let name        = json["name"].string,
            let isClosed    = json["is_closed"].bool,
            let reviewCount = json["review_count"].int,
            let categories  = json["categories"].array,
            let rating      = json["rating"].int,
            let phone       = json["phone"].string,
            let imageUrl    = json["image_url"].string,
            let displayPhone = json["display_phone"].string,
            let url         = json["url"].string,
            let price       = json["price"].string,            
            let longitude   = json["coordinates"]["longitude"].double,
            let latitude    = json["coordinates"]["latitude"].double,
            let city        = json["location"]["city"].string,
            let zipCode     = json["location"]["zip_code"].string,
            let country     = json["location"]["country"].string,
            let address     = json["location"]["address1"].string,
            let state       = json["location"]["state"].string
            else { return nil }
        
        var categoriesToAppend = [Category]()
        
        categories.forEach {
            guard let title = $0["title"].string,
                let alias = $0["alias"].string else { return }
            
            categoriesToAppend.append(Category(title: title, alias: alias))
        }
        
        let businessLocation = Location(city: city,
                                        zipCode: zipCode,
                                        country: country,
                                        address: address,
                                        state: state)
        
        devInfo = DevInfo(id: id,
                          isClosed: isClosed,
                          businessCategories: categoriesToAppend,
                          phone: phone,
                          imageUrl: imageUrl,
                          url: url, coordinate: Coordinate(latitude: latitude,
                                                           longitude: longitude))
        
        displayInfo = InfoToDisplay(rating: rating,
                                    displayPhone: displayPhone,
                                    price: price,
                                    name: name,
                                    reviewCount: reviewCount,
                                    location: businessLocation)        
        
    }
}
