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
    @IBOutlet weak var nomeParadaLabel: UILabel!
    @IBOutlet weak var nomeOnibusLabel: UILabel!
    @IBOutlet weak var busMapaView: MKMapView!
    @IBOutlet weak var onibusButton: UIButton!
    @IBOutlet var onibusTableView: UITableView!
    @IBOutlet weak var paradaTableView: UITableView!
    //Declaracoes iniciais
    let locationManager = CLLocationManager()
    let onibusList = DadosDAO.getRotaList()
    let paradaList = DadosDAO.getRotaList()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Pedindo autorizacao
        if(CLLocationManager.authorizationStatus() !=
            CLAuthorizationStatus.authorizedWhenInUse)
        {
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        //estilizacao e configs do onibusTableView
        onibusTableView.backgroundColor = UIColor.white
        onibusTableView.layer.cornerRadius = 5
        onibusTableView.layer.borderWidth = 1
        onibusTableView.layer.borderColor = UIColor.black.cgColor
        onibusTableView.isHidden = true
        onibusTableView.delegate = self
        onibusTableView.dataSource = self
        //estilizacao e configs do paradaTableView
        paradaTableView.backgroundColor = UIColor.white
        paradaTableView.layer.cornerRadius = 5
        paradaTableView.layer.borderWidth = 1
        paradaTableView.layer.borderColor = UIColor.black.cgColor
        paradaTableView.isHidden = true
        paradaTableView.delegate = self
        paradaTableView.dataSource = self
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
    
    
    //Mostrar onibusTableView ao clicar no botao Escolher onibus
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
    //Mostrar paradaTableView ao clicar no botao Paradas
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

