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
    var onibusList: [CloudantDados] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Atualizando lista de onibus
        getOnibusList()
        
        //estilizacao e configs do paradaTableView
        paradaTableView.backgroundColor = UIColor.white
        paradaTableView.layer.cornerRadius = 5
        paradaTableView.layer.borderWidth = 1
        paradaTableView.layer.borderColor = UIColor.black.cgColor
        paradaTableView.delegate = self
        paradaTableView.dataSource = self
        
        //Mostrar localizacao do usuario
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        paradaMapView.showsUserLocation = true
        paradaMapView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
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
        }
        var count1 = 0
        var count2 = 0
        for i in self.onibusList {
            
            for i in self.onibusList[count1].rota_paradas{
                
                let point = CLLocationCoordinate2D(latitude: self.onibusList[count1].rota_paradas[count2].latitude,
                                                   longitude: self.onibusList[count1].rota_paradas[count2].longitude)
                count2+=1
                self.paradaMapView.addAnnotation(point as! MKAnnotation)
                if count2 > self.onibusList[count1].rota_paradas.count{
                    count2 = 0
                    break
                }
                count1+=1
            }
        }
        DispatchQueue.main.async {
            self.paradaTableView.reloadData()
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onibusList[0].rota_paradas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onibusCell", for: indexPath)
        cell.textLabel?.text = "Parada \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let info = self.onibusList[indexPath.row]
        performSegue(withIdentifier: "onibus-Parada", sender: self)
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

