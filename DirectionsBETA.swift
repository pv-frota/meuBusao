//
//  ViewController.swift
//  directions
//
//  Created by student on 01/07/19.
//  Copyright © 2019 student. All rights reserved.
//

import MapKit
import UIKit


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapkitView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mapkitView.delegate = self
        mapkitView.showsScale = true
        mapkitView.showsPointsOfInterest = true
        mapkitView.showsUserLocation = true
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        let sourceCoordinates = locationManager.location?.coordinate
        let destCoordinates = CLLocationCoordinate2DMake(-1.471904224289479, -48.447967604095254 )
        
        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinates!)
        let destPlacemark = MKPlacemark(coordinate: destCoordinates) //creates a placemarker in the destination
        let sourceItem = MKMapItem(placemark: sourcePlacemark) //to get the direction
        let destItem = MKMapItem(placemark: destPlacemark)
        
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceItem
        directionRequest.destination = destItem
        directionRequest.transportType = .automobile // the transport type is gonna be by bus
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            response, error in
            guard let response = response else{
                if let error = error {
                    print("Deu bronca")
                }
                return
            }
            let route = response.routes[0]
            self.mapkitView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect //rekt == rectangle, bounding map rectangle
            self.mapkitView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
            
            //now we need to show the polylines, overlaying them
        }
            
            
        )
        
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5.0
        
        
        return renderer
    }
    
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

