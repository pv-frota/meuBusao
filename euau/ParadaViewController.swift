//
//  MapaView.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ParadaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate {
    //Outlets
    
    @IBOutlet weak var paradaMapView: MKMapView!
    @IBOutlet weak var paradaTableView: UITableView!
    
    //Declaracoes iniciais
    let locationManager = CLLocationManager()
    var index: Int = 0
    var onibusList: [CloudantDados] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //estilizacao e configs do paradaTableView
        tableViewConfig()
        
        //Mostrar localizacao do usuario
        locationConfig()
        
        //Nao deixar a tela apagar
        UIApplication.shared.isIdleTimerDisabled = true;
        
        //Mostrando as paradas e rotas
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            
            self.obterParadas()
            self.drawRoutes()
            
        }
    }
    
    //Obtem e mostra todas as paradas
    func obterParadas() {
        var count = 0
        for i in (onibusList[index].rota_paradas){
            
            let point = CLLocationCoordinate2D(latitude: (self.onibusList[index].rota_paradas[count].latitude),
                                               longitude: (self.onibusList[index].rota_paradas[count].longitude))
            count+=1
            let annotation = MKPointAnnotation()
            annotation.coordinate = point
            self.paradaMapView.addAnnotation(annotation)
            if count > (onibusList[index].rota_paradas.count) { break }
        }
    }
    
    //Desenhar as rotas entre as paradas
    func drawRoutes() {

        paradaMapView.delegate = self
        var count = 0
        
        for i in onibusList[index].rota_paradas {
            
            let sourceLocation = CLLocationCoordinate2D(latitude: self.onibusList[index].rota_paradas[count].latitude, longitude: self.onibusList[index].rota_paradas[count].longitude)
            let destinationLocation = CLLocationCoordinate2D(latitude: self.onibusList[index].rota_paradas[count+1].latitude, longitude: self.onibusList[index].rota_paradas[count+1].longitude)
            
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
            
            self.paradaMapView.showAnnotations(self.paradaMapView.annotations, animated: true )
            
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
                self.paradaMapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.paradaMapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
            count+=1
            if count+2 > onibusList[index].rota_paradas.count{ break }
            
        }
    }
    
    func tableViewConfig() {
        paradaTableView.backgroundColor = UIColor.white
        paradaTableView.layer.cornerRadius = 5
        paradaTableView.layer.borderWidth = 1
        paradaTableView.layer.borderColor = UIColor.black.cgColor
        paradaTableView.delegate = self
        paradaTableView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func locationConfig() {
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        paradaMapView.showsUserLocation = true
        paradaMapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        paradaMapView.isZoomEnabled = false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onibusList[index].rota_paradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paradaCell", for: indexPath)
        cell.textLabel?.text = "Parada \(indexPath.row)"
        return cell
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

