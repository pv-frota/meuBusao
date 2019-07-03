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
    var onibusList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pedindo autorizacao
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        //Atualizando lista de onibus
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

    }
    func getOnibusList() {
        CloudantDadosDAO.getOnibusList { (dado) in
            var count: Int = 0
            for i in dado {
                self.onibusList.append(dado[count].rota_nome)
                count+=1
                if count > dado.count { break }
            }
            DispatchQueue.main.async {
                self.onibusTableView.reloadData()
            }
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
        cell.textLabel?.text = onibusList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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

