//
//  Dados.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Dados {
    
    let rota_nome: String
    let rota_cod: String
    let rota_paradas: [CLLocationCoordinate2D]

    
    init(rota_nome: String, rota_cod: String, rota_paradas: [CLLocationCoordinate2D] ) {
        self.rota_nome = rota_nome
        self.rota_cod = rota_cod
        self.rota_paradas = rota_paradas
    }
}

class DadosDAO{
    
    static func getRotaList() -> [Dados]{
        //Lista de rotas
        return [
            Dados(
                rota_nome: "Curuçambá - UFPA",
                rota_cod: "999",
                rota_paradas: [CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639), CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639) ]
            ),
            Dados(
                rota_nome: "UFPA - Cidade Nova 6",
                rota_cod: "321",
                rota_paradas: [CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639), CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639) ]
            ),
            Dados(
                rota_nome: "UFPA - Circular 01",
                rota_cod: "001",
                rota_paradas: [CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639), CLLocationCoordinate2D.init(latitude: 38.88833, longitude: -77.01639) ]            ),
        ]
        
    }
    //Lista de paradas pelo codigo do onibus
    static func getParadaList(onibusSelecionado: String) -> [CLLocationCoordinate2D]{
        let dados = self.getRotaList()
        var i = 0;
        while i<=dados.count {
            if dados[i].rota_cod == onibusSelecionado {
                
                return dados[i].rota_paradas
            } else {
                i += 1
            }
        }
        
        return [CLLocationCoordinate2D.init()]
    }
    
    
}
