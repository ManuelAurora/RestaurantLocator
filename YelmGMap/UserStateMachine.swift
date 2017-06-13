//
//  UserStateMachine.swift
//  YelmGMap
//
//  Created by Manuel Aurora on 08.06.17.
//  Copyright © 2017 Manuel Aurora. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate let userDefaults = UserDefaults.standard
fileprivate let userDefTokenKey = String(describing: YelpRequestRouter.accessToken)

class UserStateMachine: NSObject
{
    static let shared = UserStateMachine()
    
    fileprivate let nc = NotificationCenter.default
    
    fileprivate lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.delegate = self
        
        return manager
    }()
    
    var businesess = [Business]()
    var currentMapZoom: Float = 17
       
    fileprivate var isProperValueRecieved: Bool = false
    private var timer: Timer?
    private var _userLocation: CLLocation?
    private var testLocation: CLLocation {
        let loc = CLLocation(latitude: 37.774929 ,
                             longitude: -122.419416)
        return loc
    }
    
    var searchLocation = CLLocationCoordinate2D()
    
    var token: Token? {
        guard let tokenData = userDefaults.data(forKey: userDefTokenKey),
            let token = NSKeyedUnarchiver.unarchiveObject(with: tokenData) as? Token else {
                return nil
        }
        return token
    }    
    
    var userLocation: CLLocation? {
        set {
            _userLocation = newValue
        }
        get {
            
            if let usrLoc = _userLocation
            {
                return usrLoc
            }
            else
            {
                return nil
            }
        }
    }
    
    func updateUserLocation() {
        
        guard authorized() else { locationManager.requestLocation(); return }
        
        locationManager.startUpdatingLocation()
        
        timer = Timer(timeInterval: 30,
                      target: self,
                      selector: #selector(timeOut),
                      userInfo: nil,
                      repeats: false)
    }
    
    @objc private func timeOut() {
        
        locationManager.stopUpdatingLocation()
    }
    
    private func requestAuthorization() {
        
         locationManager.requestWhenInUseAuthorization()
    }
    
    private func authorized() -> Bool {
        
        let authStatus = CLLocationManager.authorizationStatus()
        
        switch authStatus
        {
        case .authorizedAlways, .authorizedWhenInUse: return true
        case .denied, .restricted:
            let title = "Location Services Disabled"
            let message = "Please enable location services for this app in Settings."
            showAlertWith(title: title, message: message)
            return false
            
        default: return false
        }
    }
    
    fileprivate func showAlertWith(title: String, message: String) {
       
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertController.addAction(okAction)
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController,
                                                                    animated: true,
                                                                    completion: nil)
    }
    
    func save(token: Token) {
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: token)
        
        userDefaults.setValue(encodedData, forKey: userDefTokenKey)
    }
}

extension UserStateMachine: CLLocationManagerDelegate
{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let newLoc = locations.last
        {
            if newLoc.timestamp.timeIntervalSinceNow < TimeInterval(-5) { return }
            if newLoc.horizontalAccuracy < 0 { return }
            
            if userLocation == nil || userLocation!.horizontalAccuracy < newLoc.horizontalAccuracy
            {
                userLocation = newLoc
            }
            
            if !isProperValueRecieved || newLoc.horizontalAccuracy >= locationManager.desiredAccuracy
            {
                isProperValueRecieved = true
                locationManager.stopUpdatingLocation()
                nc.post(name: .didRecieveCoordinate, object: nil)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        showAlertWith(title: "Error Occured", message: error.localizedDescription)
    }
}
