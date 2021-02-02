//
//  MapView.swift
//  BaseDemo
//
//  Created by macOS on 9/24/20.
//  Copyright © 2020 BASEBS. All rights reserved.
//
import UIKit
import MapKit

class MapView: BaseView {
    
    private var mapView: MKMapView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        mapView = MKMapView()
        self.addSubview(mapView)
        mapView.delegate = self
    }
    
    override func layoutSubviews() {
        mapView.frame = self.bounds
        
        // Set initial location in Honolulu
        if mapView != nil {
            Logger.info("debug \(mapView.bounds)")
//            onUpdateLocation(BASEBS_HCM)
        }
    }
    
    func onUpdateLocation(_ location: CLLocation) {
        mapView.centerToLocation(location)
//        setCamera(on: location)
        addAnnotation(on: location)
        
        layoutIfNeeded()
    }
    
    func setCamera(on location: CLLocation) {
        let region = MKCoordinateRegion(
          center: location.coordinate,
          latitudinalMeters: 50_000,
          longitudinalMeters: 60_000)
        
        if #available(iOS 13.0, *) {
            mapView.setCameraBoundary(
                MKMapView.CameraBoundary(coordinateRegion: region),
                animated: true)
        } else {
            // Fallback on earlier versions
            
        }
        
        if #available(iOS 13.0, *) {
            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200_000)
            mapView.setCameraZoomRange(zoomRange, animated: true)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    func addAnnotation(on location: CLLocation) {
        // Show artwork on map
        let artwork = Artwork(
          title: "BASE BS",
          locationName: "VN",
          discipline: "SE",
          coordinate: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        mapView.addAnnotation(artwork)
    }

}

extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        
        setRegion(coordinateRegion, animated: true)
    }
}

extension MapView: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else {
          return nil
        }
        // 3
        let identifier = "artwork"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(
          withIdentifier: identifier) as? MKMarkerAnnotationView {
          dequeuedView.annotation = annotation
          view = dequeuedView
        } else {
          // 5
          view = MKMarkerAnnotationView(
            annotation: annotation,
            reuseIdentifier: identifier)
          view.canShowCallout = true
          view.calloutOffset = CGPoint(x: -5, y: 5)
          view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
}

class Artwork: NSObject, MKAnnotation {
  let title: String?
  let locationName: String?
  let discipline: String?
  let coordinate: CLLocationCoordinate2D

  init(
    title: String?,
    locationName: String?,
    discipline: String?,
    coordinate: CLLocationCoordinate2D
  ) {
    self.title = title
    self.locationName = locationName
    self.discipline = discipline
    self.coordinate = coordinate

    super.init()
  }

  var subtitle: String? {
    return locationName
  }
}
