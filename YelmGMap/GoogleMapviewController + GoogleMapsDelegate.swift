//
//  GoogleMapviewController + GoogleMapsDelegate.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 09.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import GoogleMaps
import MapKit

extension GoogleMapViewController: GMSMapViewDelegate
{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        gMapViewModel.setCurrentMapZoom(mapView.camera.zoom)
        gMapViewModel.setCurrentSearchLocation(mapView.camera.target)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
        makeRequest()
    }
    
    
}
