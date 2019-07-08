//
//  RotasTableView.swift
//  euau
//
//  Created by student on 24/06/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit

class RotasTableView: UITableViewController {
    
    var rotas = [CloudantDados]()
    var infoToParada: Array<Any> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CloudantDadosDAO.getOnibusList { (dado) in
            var count: Int = 0
            for _ in dado {
                self.rotas.append(dado[count])
                count+=1
                if count > dado.count { break }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return rotas.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rotaCell", for: indexPath)
        
        if let rotaCell = cell as? RotasTableViewCell{
            
            let rota = rotas[indexPath.row]
            
            rotaCell.Cod_NomeLabel.text = "\(rota.rota_cod) - \(rota.rota_nome)"
            
            return rotaCell
        }
        
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        infoToParada = [indexPath.row, rotas]
        performSegue(withIdentifier: "cellSegue", sender: infoToParada)
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let novaView = segue.destination as? DetalharRotaView, let detailToSend = sender as? Array<Any> {
            print(detailToSend)
            novaView.index = detailToSend[0] as! Int
            novaView.rotaSelecionada = detailToSend[1] as! [CloudantDados]
        }
        
    }
    
    
}
