//
//  GoogleMapViewModel.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import Foundation
import CoreLocation

class GoogleMapViewModel
{
    private let stateMachine = UserStateMachine.shared
    
    func getCurrentUserCoordinates() -> Coordinate? {
        
        if let coordinate = stateMachine.userLocation?.coordinate
        {
            return Coordinate(latitude: coordinate.latitude,
                              longitude: coordinate.longitude)
        }
        return nil
    }
    
    func getCurrentMapZoom() -> Float {
        
        return stateMachine.currentMapZoom
    }
    
    func setCurrentMapZoom(_ zoom: Float) {
        
        stateMachine.currentMapZoom = zoom
    }
    
    func setCurrentSearchLocation(_ coord: CLLocationCoordinate2D) {
        
        stateMachine.searchLocation = coord
    }
    
    func getCurrentSearchLocation() -> CLLocationCoordinate2D {
        
        return stateMachine.searchLocation
    }
    
    func getBusinesess() -> [Business] {
        
        return stateMachine.businesess
    }
}
