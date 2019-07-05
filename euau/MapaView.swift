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

class MapaView: UIViewController,UITableViewDelegate,UITableViewDataSource,MKMapViewDelegate,CLLocationManagerDelegate {
    //Outlets
    @IBOutlet weak var busMapaView: MKMapView!
    @IBOutlet var onibusTableView: UITableView!
    
    //Declaracoes iniciais
    let locationManager = CLLocationManager()
    var onibusList: [CloudantDados] = []
    var infoToParada: CloudantDados? = nil
    var newLista: [CloudantDados] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pedindo autorizacao
        getAutorization()
        
        //Atualizando e mostrando lista de onibus
        getOnibusList()
        
        //estilizacao e configs do onibusTableView
        tableViewConfig()
        
        //Mostrar localizacao do usuario
        locationConfig()
        
        //Nao deixar a tela apagar
        UIApplication.shared.isIdleTimerDisabled = true;
        /*
         drawRoutes()
        */
        
    }
    
    func atualizarList(){
        self.getNewOnibusList()
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // Change `2.0` to the desired number of seconds.
            
            if self.onibusList[0].rota_localizacao[0].latitude != self.newLista[0].rota_localizacao[0].latitude || self.onibusList[0].rota_localizacao[0].longitude != self.newLista[0].rota_localizacao[0].longitude
            {
                self.onibusList = self.newLista
                self.atualizarOnibus()
            }
        }
    }
    //Obtem a autorizacao de localizacao
    func getAutorization() {
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Update the view at roughly 10Hz
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
            //Edit: example update of the data before redrawing
            self.atualizarList()
            
            self.setNeedsFocusUpdate()
        })
    }
    
    //Obtem a lista de onibus
    func getOnibusList() {
        CloudantDadosDAO.getOnibusList { (dado) in
            var count: Int = 0
            for _ in dado {
                self.onibusList.append(dado[count])
                count+=1
                if count > dado.count { break }
            }
            DispatchQueue.main.async {
                self.onibusTableView.reloadData()
                self.atualizarOnibus()
            }
        }
    }
    
    func getNewOnibusList(){
        newLista = []
        CloudantDadosDAO.getOnibusList { (dado) in
            var count: Int = 0
            for _ in dado {
                self.newLista.append(dado[count])
                count+=1
                if count > dado.count { break }
            }
        }
    }
    //Mostrar os pinos de localizacao dos onibus
    func atualizarOnibus() {
        if busMapaView.annotations != nil {
            busMapaView.removeAnnotations(busMapaView.annotations)
        }
        var count1 = 0
        for _ in self.onibusList {
            for _ in self.onibusList[count1].rota_localizacao{
                let point = CLLocationCoordinate2D(latitude: self.onibusList[count1].rota_localizacao[0].latitude,
                                                   longitude: self.onibusList[count1].rota_localizacao[0].longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = point
                self.busMapaView.addAnnotation(annotation)
            }
            count1+=1
            
        }
    }
    func tableViewConfig() {
        onibusTableView.backgroundColor = UIColor.white
        onibusTableView.layer.cornerRadius = 5
        onibusTableView.layer.borderWidth = 1
        onibusTableView.layer.borderColor = UIColor.black.cgColor
        onibusTableView.delegate = self
        onibusTableView.dataSource = self
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func locationConfig() {
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        busMapaView.showsUserLocation = true
        busMapaView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
    }
    /*
    func drawRoutes() {
        busMapaView.delegate = self

        // 2.
        let sourceLocation = CLLocationCoordinate2D(latitude: -1.4730696931148428, longitude: -48.45182583574734)
        let destinationLocation = CLLocationCoordinate2D(latitude: -1.4735201552650845, longitude: -48.454465129418)
        
        // 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.busMapaView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.busMapaView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.busMapaView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    */
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onibusList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onibusCell", for: indexPath)
        cell.textLabel?.text = onibusList[indexPath.row].rota_nome
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoToParada = onibusList[indexPath.row]
        performSegue(withIdentifier: "onibus-Parada", sender: infoToParada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let paradaView = segue.destination as? ParadaViewController, let detailToSend = sender as? CloudantDados {
            paradaView.lista = detailToSend
        }
    }
    /*
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }
 */
}


