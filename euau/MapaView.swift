//
//  MapaView.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class MapaView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var nomeOnibusLabel: UILabel!
    
    @IBOutlet weak var onibusButton: UIButton!
    @IBOutlet var onibusTableView: UITableView!
    
    
    let onibusList = DadosDAO.getRotaList()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onibusTableView.backgroundColor = UIColor.white
        onibusTableView.layer.cornerRadius = 5
        onibusTableView.layer.borderWidth = 1
        onibusTableView.layer.borderColor = UIColor.black.cgColor
        
        onibusTableView.isHidden = true

        onibusTableView.delegate = self
        onibusTableView.dataSource = self

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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

