//
//  ViewController.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController
{
    let gMapViewModel = GoogleMapViewModel()
    
    private var mapView: GMSMapView = {
        let mv = GMSMapView()
        mv.isMyLocationEnabled = true
        return mv
    }()
    
    var businesess = [Business]() {
        didSet {
            updateMap()
        }
    }
    
    private let nc = NotificationCenter.default
    
    override func loadView() {
        
        view = mapView
        setCamera()
    }
    
    private func setCamera() {
        guard let coordinate = gMapViewModel.getCurrentUserCoordinates() else {
            return
        }
        
        let zoom = gMapViewModel.getCurrentMapZoom()
        let camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                              longitude: coordinate.longitude,
                                              zoom: zoom)
        
        mapView.camera = camera
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self 
        view.backgroundColor = .white
        subscribeToNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        YelpRequestRouter.accessToken.get()
    }
        
    private func updateMap() {
        
        businesess.forEach { business in
            guard business.isOnTheMap == false else { return }
            
            business.setOnMap()
            
            let marker = GMSMarker()
            let coord = business.devInfo.coordinate
            marker.position = CLLocationCoordinate2D(latitude: coord.latitude,
                                                     longitude: coord.longitude)
            
            marker.title = business.displayInfo.name
            marker.snippet = business.displayInfo.location.address
            marker.appearAnimation = .pop           
            marker.map = mapView
        }        
    }
    
    private func subscribeToNotifications() {
        
        nc.addObserver(self,
                       selector: #selector(getRestaurants),
                       name: .didRecieveCoordinate,
                       object: nil)
        
        nc.addObserver(self, selector: #selector(getBusinesses),
                       name: .didRecieveBusinesess,
                       object: nil)
    }
    
    @objc private func getBusinesses() {
        
       businesess = gMapViewModel.getBusinesess()
    }
    
    @objc private func getRestaurants() {
        
        makeRequest()
        setCamera()
    }
    
    func makeRequest() {
        
        let radiusString = "\(getRadius())"
        
        YelpRequestRouter.businesess("restaurants",
                                     radius: radiusString).get()
    }
    
    // calculate radius
    private func getCenterCoordinate() -> CLLocationCoordinate2D {
        
        let centerPoint = mapView.center
        let centerCoordinate = mapView.projection.coordinate(for: centerPoint)
        
        return centerCoordinate
    }
    
    private func getTopCenterCoordinate() -> CLLocationCoordinate2D {
        
        let p             = CGPoint(x: mapView.frame.size.width / 2, y: 0)
        let topCenterCoor = mapView.convert(p, from: mapView)
        let point         = mapView.projection.coordinate(for: topCenterCoor)
        
        return point
    }
    
    func getRadius() -> Int {
        
        let centerCoordinate = getCenterCoordinate()
        let centerLocation = CLLocation(latitude: centerCoordinate.latitude, longitude: centerCoordinate.longitude)
        let topCenterCoordinate = getTopCenterCoordinate()
        let topCenterLocation = CLLocation(latitude: topCenterCoordinate.latitude, longitude: topCenterCoordinate.longitude)
        
        let radius = CLLocationDistance(centerLocation.distance(from: topCenterLocation))
       
        return Int(round(radius))
    }
}

