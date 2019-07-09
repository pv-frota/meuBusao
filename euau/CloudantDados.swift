//
//  CloundantDados.swift
//  euau
//
//  Created by Pedro Victor on 02/07/2019.
//  Copyright © 2017 Pedro Victor. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CloudantDados {
    
    var onibus_id: String
    var rota_nome: String
    var rota_cod: String
    var rota_paradas: [Paradas]
    var rota_localizacao: [Localizacao]
    
    init(json: [String: AnyObject]) {
        self.onibus_id = json["_id"] as? String ?? ""
        self.rota_nome = json["nome"] as? String ?? ""
        self.rota_cod = json["linha"] as? String ?? ""
        self.rota_localizacao = [Localizacao]()
        self.rota_paradas = [Paradas]()
        
        if let coordenadas = json["localizacao"] as? [String: Double]{
            let novaLocalizacao = Localizacao(json: coordenadas)
            self.rota_localizacao.append(novaLocalizacao)
            
        }
        
        if let paradas = json["paradas"] as? [ [String: Double] ] {
            for jsonParada in paradas {
                let novaParada = Paradas(json: jsonParada)
                self.rota_paradas.append(novaParada)
            }
        }
    }
}

class Paradas {
    var latitude: Double
    var longitude: Double
    
    init(json: [String: Double]) {
        self.latitude = json["latitude"] ?? 0
        self.longitude = json["longitude"] ?? 0
    }
}

class Localizacao {
    var latitude: Double
    var longitude: Double
    
    init(json: [String: Double]){
        self.latitude = json["latitude"] ?? 0
        self.longitude = json["longitude"] ?? 0
        
    }
}

class CloudantDadosDAO {
    
    static func getOnibusList (callback: @escaping ((Array<CloudantDados>) -> Void)) {
        
        let endpoint: String = "https://aula-iot-andre-005.mybluemix.net/listOnibus"
        
        guard let url = URL(string: endpoint) else {
            print("Erroooo: Cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Error = \(String(describing: error))")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print(responseString ?? "")
            
            DispatchQueue.main.async() {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]] {
                        //Seleciona um onibus pela posicao no banca
                        var dado: Array<CloudantDados> = []
                        var count: Int = 0
                        for _ in json {
                            dado.append(CloudantDados(json: json[count]))
                            count += 1
                            if count > json.count {
                                break
                            }
                        }
                        
                        
                        callback(dado)
                        
                    }else {
                        
                        print("fudeuuuu")
                    }
                } catch let error as NSError {
                    print("Error = \(error.localizedDescription)")
                }
            }
            
            
        })
        
        task.resume()
    }
    
    static func getOnibusPosition (id: String, callback: @escaping (CloudantDados) -> Void) {
        print(" id - " + id)
        let endpoint: String = "https://aula-iot-andre-005.mybluemix.net/listOnibusById/?_id=" + id
        
        guard let url = URL(string: endpoint) else {
            print("Erroooo: Cannot create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            if error != nil {
                print("Error = \(String(describing: error))")
                return
            }
            
            let responseString = String(data: data!, encoding: String.Encoding.utf8)
            print(responseString ?? "")
            
            DispatchQueue.main.async() {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: AnyObject] {
                        
                        let dado: CloudantDados? = CloudantDados(json: json)
                        
                        print("entrou no obter")
                        callback(dado!)
                        
                    }else {
                        

                        print("nao entrou")
                    }
                } catch let error as NSError {
                    print("Error = \(error.localizedDescription)")
                }
            }
            
            
        })
        
        task.resume()
    }

    
    
}
