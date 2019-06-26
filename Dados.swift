//
//  Dados.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import Foundation

class Dados {
    
    let rota_nome: String
    let rota_cod: String
    let rota_paradas: Array<String>

    
    init(rota_nome: String, rota_cod: String, rota_paradas: Array<String>) {
        self.rota_nome = rota_nome
        self.rota_cod = rota_cod
        self.rota_paradas = rota_paradas
    }
}

class DadosDAO{
    
    static func getRotaList() -> [Dados]{
        
        return [
            Dados(
                rota_nome: "Curuçambá - UFPA",
                rota_cod: "999",
                rota_paradas: ["Teste", "Teste2", "..."]
            ),
            Dados(
                rota_nome: "UFPA - Cidade Nova 6",
                rota_cod: "321",
                rota_paradas: ["Teste", "Teste2", "..."]
            ),
            Dados(
                rota_nome: "UFPA - Tamoios",
                rota_cod: "322",
                rota_paradas: ["Teste", "Teste2", "..."]
            ),
        ]
        
    }
    
}
