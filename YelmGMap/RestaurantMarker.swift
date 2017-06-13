//
//  RestaurantMarker.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 13.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import GoogleMaps

class RestaurantMarker: GMSMarker
{
    let restaurant: Business?
    
    init(restaurant: Business) {
        self.restaurant = restaurant
    }
}
