//
//  LocationManager.swift
//  BaseDemo
//
//  Created by macOS on 11/20/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private var locationManager: CLLocationManager?
    private override init(){
        self.locationManager = CLLocationManager()
        
    }
    
    var clLocationNameHandler: ((String) -> Void)?
    
    func request() {
        
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager?.startUpdatingLocation()
            }
            
            let runloop = RunLoop.current
            let thread = Thread.current
            print("khiemht")
            print(thread.isMainThread)
            print(runloop)
        }
        
    }
    
    func requestAccessLocation() {
        print("debug request")
        
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            
        } else if status == .authorizedAlways {
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last as! CLLocation
        manager.stopUpdatingLocation()
        
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                return
            }
            
            if let placemark = placemarks?.last {
                if let locality = placemark.locality, let area = placemark.administrativeArea, let country = placemark.country {
                    let locationName = locality + ", " + area + ", " + country
                    DispatchQueue.main.async {
                        self.clLocationNameHandler!(locationName)
                    }
                }
   
            }
  
        }
    }
}
