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
    
    @IBOutlet weak var nomeParadaLabel: UILabel!
    @IBOutlet weak var nomeOnibusLabel: UILabel!
    @IBOutlet weak var busMapaView: MKMapView!
    @IBOutlet weak var onibusButton: UIButton!
    @IBOutlet var onibusTableView: UITableView!
    @IBOutlet weak var paradaTableView: UITableView!
    @IBOutlet weak var speedLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let onibusList = DadosDAO.getRotaList()
    let paradaList = DadosDAO.getRotaList()
    
    static let numberFormatter: NumberFormatter =  {
        let mf = NumberFormatter()
        mf.minimumFractionDigits = 0
        mf.maximumFractionDigits = 0
        return mf
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }

        onibusTableView.backgroundColor = UIColor.white
        onibusTableView.layer.cornerRadius = 5
        onibusTableView.layer.borderWidth = 1
        onibusTableView.layer.borderColor = UIColor.black.cgColor
        onibusTableView.isHidden = true
        onibusTableView.delegate = self
        onibusTableView.dataSource = self
        
        paradaTableView.backgroundColor = UIColor.white
        paradaTableView.layer.cornerRadius = 5
        paradaTableView.layer.borderWidth = 1
        paradaTableView.layer.borderColor = UIColor.black.cgColor
        paradaTableView.isHidden = true
        paradaTableView.delegate = self
        paradaTableView.dataSource = self
        
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        busMapaView.showsUserLocation = true
        busMapaView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        
        UIApplication.shared.isIdleTimerDisabled = true;

    }
    
    

    @IBAction func onibusButtonClick(sender: AnyObject){
    
        if onibusTableView.isHidden == true {
            if paradaTableView.isHidden == false{
                paradaTableView.isHidden = true
            }
            onibusTableView.isHidden = false
        } else {
            onibusTableView.isHidden = true
        }
    }

    @IBAction func paradaButtonClick(sender: AnyObject){
        
        if paradaTableView.isHidden == true {
            if onibusTableView.isHidden == false{
                onibusTableView.isHidden = true
            }

            paradaTableView.isHidden = false
        } else {
            paradaTableView.isHidden = true
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if tableView == self.onibusTableView {
            count = onibusList.count
        }
        
        if tableView == self.paradaTableView {
            count =  paradaList.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell?
        
        if tableView == self.onibusTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "onibusCell", for: indexPath)
            cell?.textLabel?.text = onibusList[indexPath.row].rota_nome
            
        }
        
        if tableView == self.paradaTableView {
            cell = tableView.dequeueReusableCell(withIdentifier: "paradaCell", for: indexPath)
            cell?.textLabel?.text = paradaList[indexPath.row].rota_nome
            
        }
        
        return cell!
    }
    
    //for i in listaParadas
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.onibusTableView {
            let onibusSelecionado = onibusList[indexPath.row].rota_nome
            nomeOnibusLabel.text = onibusSelecionado
            print(DadosDAO.getParadaList(onibusSelecionado: onibusList[indexPath.row].rota_cod))
            if onibusTableView.isHidden == false {
                onibusTableView.isHidden = true
            }
        }
        
        if tableView == self.paradaTableView {
            let paradaSelecionada = paradaList[indexPath.row].rota_nome
            nomeParadaLabel.text = paradaSelecionada
            if paradaTableView.isHidden == false {
                paradaTableView.isHidden = true
            }
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        if(newLocation.speed > 0) {
            let kmh = newLocation.speed / 1000.0 * 60.0 * 60.0
            if let speed = MapaView.numberFormatter.string(from: NSNumber(value: kmh)) {
                self.speedLabel.text = "\(speed) km/h"
            }
        }
        else {
            self.speedLabel.text = "---"
        }
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

