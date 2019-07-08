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

class CustomPointAnnotation: MKPointAnnotation {
    var imageName: String!
}

class ParadaViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate {
    //Outlets
    
    @IBOutlet weak var paradaMapView: MKMapView!
    @IBOutlet weak var paradaTableView: UITableView!
    
    //Declaracoes iniciais
    let locationManager = CLLocationManager()
    var index: Int = 0
    var onibusList: [CloudantDados] = []
    var newPosition: CloudantDados? = nil
    var busAnnotation = CustomPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //estilizacao e configs do paradaTableView
        tableViewConfig()
        
        //Mostrar localizacao do usuario
        locationConfig()
        
        //Nao deixar a tela apagar
        UIApplication.shared.isIdleTimerDisabled = true;
        
        //Mostrando as paradas, rotas e inicializando a posição do ônibus
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            
            self.obterParadas()
            self.drawRoutes()
            self.obterOnibusPosition()

        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        //Atualizando a posição do onibus a cada 5 secs
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
            
            self.atualizarPosicao()
            self.setNeedsFocusUpdate()
            
        })
    }
    //Atualiza a posição do ônibus
    func atualizarPosicao() {
        CloudantDadosDAO.getOnibusPosition(id: onibusList[index].onibus_id) { (dado) in
            self.newPosition = dado
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if self.onibusList[self.index].rota_localizacao[0].latitude != self.newPosition!.rota_localizacao[0].latitude || self.onibusList[self.index].rota_localizacao[0].longitude != self.newPosition?.rota_localizacao[0].longitude
            {
                self.paradaMapView.removeAnnotation(self.busAnnotation)
                self.onibusList[self.index] = self.newPosition!
                self.obterOnibusPosition()
            }
        }
    }
    //Mostra a posição do ônibus no mapa
    func obterOnibusPosition() {
        let point = CLLocationCoordinate2D(latitude: (self.onibusList[index].rota_localizacao[0].latitude),
                                           longitude: (self.onibusList[index].rota_localizacao[0].longitude))
        self.busAnnotation.coordinate = point
        self.busAnnotation.imageName = "busPin"
        self.paradaMapView.addAnnotation(self.busAnnotation)
    }
    //Obtem e mostra todas as paradas
    func obterParadas() {
        var count = 0
        for _ in (onibusList[index].rota_paradas){
            
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
        
        for _ in onibusList[index].rota_paradas {
            
            let sourceLocation = CLLocationCoordinate2D(latitude: self.onibusList[index].rota_paradas[count].latitude, longitude: self.onibusList[index].rota_paradas[count].longitude)
            let destinationLocation = CLLocationCoordinate2D(latitude: self.onibusList[index].rota_paradas[count+1].latitude, longitude: self.onibusList[index].rota_paradas[count+1].longitude)
            
            let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
            
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
            
            let sourceAnnotation = MKPointAnnotation()
            
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
                sourceAnnotation.title = "Parada \(count)"
                sourceAnnotation.subtitle = "Parada \(count)"
            }
            
            let destinationAnnotation = MKPointAnnotation()
            
            if let location = destinationPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
                destinationAnnotation.title = "Parada \(count+1)"
                destinationAnnotation.subtitle = "Parada \(count+1)"
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
        paradaMapView.isZoomEnabled = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onibusList[index].rota_paradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paradaCell", for: indexPath)
        cell.textLabel?.text = "Parada \(indexPath.row+1)"
        return cell
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is CustomPointAnnotation) {
            return nil
        }

        let reuseId = "test"
        
        var anView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
        if anView == nil {
            anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            anView?.canShowCallout = true
        }
        else {
            anView?.annotation = annotation
        }
        
        //Set annotation-specific properties **AFTER**
        //the view is dequeued or created...
        
        let cpa = annotation as! CustomPointAnnotation
        // Resize image
        let pinImage = UIImage(named: cpa.imageName)
        let size = CGSize(width: 35, height: 35)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        anView?.image = resizedImage
        
        return anView
    }

}

