//
//  DetalharRotaView.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DetalharRotaView: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
    
    var rotaSelecionada: [CloudantDados] = []
    let locationManager = CLLocationManager()
    var index = 1

    
    @IBOutlet weak var rotaMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        locationConfig()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            self.title = self.rotaSelecionada[self.index].rota_nome
            self.drawRoutes()
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawRoutes() {
        print("entrou")
        rotaMapView.delegate = self
        var count = 0
        
        for _ in (rotaSelecionada[index].rota_paradas) {
            print(self.rotaSelecionada[index].rota_paradas[count].latitude)
            print(self.rotaSelecionada[index].rota_paradas[count].longitude)
            let sourceLocation = CLLocationCoordinate2D(latitude: self.rotaSelecionada[index].rota_paradas[count].latitude, longitude: self.rotaSelecionada[index].rota_paradas[count].longitude)
            let destinationLocation = CLLocationCoordinate2D(latitude: self.rotaSelecionada[index].rota_paradas[count+1].latitude, longitude: self.rotaSelecionada[index].rota_paradas[count+1].longitude)
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let sourceAnnotation = MKPointAnnotation()
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate

            }
            
            let destinationAnnotation = MKPointAnnotation()
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate

            }
            
            self.rotaMapView.showAnnotations(self.rotaMapView.annotations, animated: true )
            
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = destinationMapItem
            directionRequest.transportType = .any
            
            let directions = MKDirections(request: directionRequest)
            
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    
                    return
                }
                
                let route = response.routes[0]
                self.rotaMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
            }
            count+=1
            if count+2 > (rotaSelecionada[index].rota_paradas.count){ break }
            
        }
    }
    
    func locationConfig() {
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        rotaMapView.showsUserLocation = true
        rotaMapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        rotaMapView.isZoomEnabled = true
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
