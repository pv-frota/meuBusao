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
    
    @IBOutlet weak var nomeOnibusLabel: UILabel!
    @IBOutlet weak var busMapaView: MKMapView!
    @IBOutlet weak var onibusButton: UIButton!
    @IBOutlet var onibusTableView: UITableView!
    @IBOutlet weak var speedLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let onibusList = DadosDAO.getRotaList()
    
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
        
        locationManager.activityType = CLActivityType.otherNavigation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        busMapaView.showsUserLocation = true
        busMapaView.setUserTrackingMode(MKUserTrackingMode.follow, animated: true)
        // Stop the display going asleep
        UIApplication.shared.isIdleTimerDisabled = true;

    }
    
    

    @IBAction func onibusButtonClick(sender: AnyObject){
    
        if onibusTableView.isHidden == true {
            onibusTableView.isHidden = false
        } else {
            onibusTableView.isHidden = true
        }
    
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onibusList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "onibusCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = onibusList[indexPath.row].rota_nome
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let onibusSelecionado = onibusList[indexPath.row].rota_nome
        nomeOnibusLabel.text = onibusSelecionado
        if onibusTableView.isHidden == false {
            onibusTableView.isHidden = true
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

