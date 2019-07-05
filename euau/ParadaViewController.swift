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
    var lista: CloudantDados? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Mostrando as paradas
        obterParadas()
        
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
        paradaMapView.isZoomEnabled = false
        
        //Nao deixar a tela apagar
        UIApplication.shared.isIdleTimerDisabled = true;
        
        // Transparent navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    func obterParadas() {
        var count = 0
        for i in (lista?.rota_paradas)!{
            
            let point = CLLocationCoordinate2D(latitude: (self.lista?.rota_paradas[count].latitude)!,
                                               longitude: (self.lista?.rota_paradas[count].longitude)!)
            count+=1
            let annotation = MKPointAnnotation()
            annotation.coordinate = point
            self.paradaMapView.addAnnotation(annotation)
            if count > (lista?.rota_paradas.count)! { break }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (lista?.rota_paradas.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paradaCell", for: indexPath)
        cell.textLabel?.text = "Parada \(indexPath.row)"
        return cell
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

