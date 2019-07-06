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
    var infoToParada: Array<Any> = []
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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Atualizando a posição do onibus a cada 5 secs
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true, block: { (timer) in
            
            self.atualizarList()
            
            self.setNeedsFocusUpdate()
            
        })
    }
    
    //Obtem a autorizacao de localizacao
    func getAutorization() {
        
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
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
    //Pega as localizacoes mais recentes do banco e atualiza as atuais
    func atualizarList(){
        
        self.getNewOnibusList()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            
            if self.onibusList[0].rota_localizacao[0].latitude != self.newLista[0].rota_localizacao[0].latitude || self.onibusList[0].rota_localizacao[0].longitude != self.newLista[0].rota_localizacao[0].longitude
            {
                self.onibusList = self.newLista
                self.atualizarOnibus()
            }
        }
    }
    
    //Nova requisição
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
        infoToParada = [indexPath.row, onibusList]
        performSegue(withIdentifier: "onibus-Parada", sender: infoToParada)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let paradaView = segue.destination as? ParadaViewController, let detailToSend = sender as? Array<Any> {
            paradaView.index = detailToSend[0] as! Int
            paradaView.onibusList = detailToSend[1] as! [CloudantDados]
        }
    }
    
    
}


