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
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        let view = MarkerView(frame: CGRect(origin: marker.infoWindowAnchor,
                                            size: CGSize(width: 180,
                                                         height: 100)))
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layoutViews()
        view.titleLabel.text = marker.title
        view.descriptionLabel.text = marker.snippet
        view.ratingLabel.text = getRatingFor(marker: marker)
            
        return view
    }
    
    private func getRatingFor(marker: GMSMarker) -> String {
        
        let business = businesess.filter {
            $0.displayInfo.name == marker.title &&
                $0.displayInfo.location.address == marker.snippet
            }.first
        var ratingString = ""
        
        if let business = business
        {
            let rating = business.displayInfo.rating
            
            
            for _ in 0..<rating
            {
                ratingString += "⭐️"
            }
        }
        return ratingString
    }
    
}
