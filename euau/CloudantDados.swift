//
//  EstacionamentoDAO.swift
//  AppIOT
//
//  Created by Bruno Corte on 14/07/17.
//  Copyright © 2017 Felipe Corte. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class CloudantDados {
    
    var rota_nome: String
    var rota_cod: String
    var rota_paradas: [Paradas]
    
    
    init(json: [String: AnyObject]) {
        self.rota_nome = json["nome"] as? String ?? ""
        self.rota_cod = json["linha"] as? String ?? ""
        
        self.rota_paradas = [Paradas]()
        
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

class CloudantDadosDAO {
    
    static func getEstacionamentos (callback: @escaping ((Array<CloudantDados>) -> Void)) {
        
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
            print("responseString = \(String(describing: responseString))")
            
            DispatchQueue.main.async() {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [[String: AnyObject]] {
                        //Seleciona um onibus pela posicao no banca
                        var dado: Array<CloudantDados> = []
                        var count: Int = 0
                        for i in json {
                            dado.append(CloudantDados(json: json[count]))
                            count += count + 1
                            if count > json.count {
                                break
                            }
                        }
                        
                        let nomeDado = dado[2].rota_nome
                        
                        print("\(nomeDado) tem \(dado[2].rota_paradas.count) paradas.")
                        
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
    
    
}
