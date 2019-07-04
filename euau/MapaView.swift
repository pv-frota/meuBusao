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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pedindo autorizacao
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        //Atualizando e mostrando lista de onibus
        getOnibusList()
        
        //estilizacao e configs do onibusTableView
        onibusTableView.backgroundColor = UIColor.white
        onibusTableView.layer.cornerRadius = 5
        onibusTableView.layer.borderWidth = 1
        onibusTableView.layer.borderColor = UIColor.black.cgColor
        onibusTableView.delegate = self
        onibusTableView.dataSource = self
        
        //Mostrar localizacao do usuario
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        busMapaView.showsUserLocation = true
        busMapaView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        //Nao deixar a tela apagar
        UIApplication.shared.isIdleTimerDisabled = true;
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        
    }
    func getOnibusList() {
        CloudantDadosDAO.getOnibusList { (dado) in
            var count: Int = 0
            for i in dado {
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
    func atualizarOnibus() {
        print("entrar")
        var count1 = 0
        for i in self.onibusList {
            print("entrou")
            for i in self.onibusList[count1].rota_localizacao{
                print("entrou")
                let point = CLLocationCoordinate2D(latitude: self.onibusList[count1].rota_localizacao[0].latitude,
                                                   longitude: self.onibusList[count1].rota_localizacao[0].longitude)
                let annotation = MKPointAnnotation()
                annotation.coordinate = point
                self.busMapaView.addAnnotation(annotation)
            }
            count1+=1
            
        }
    }
    
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
    
}


