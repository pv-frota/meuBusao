//
//  TableViewController.swift
//  tabview
//
//  Created by student on 03/07/19.
//  Copyright © 2019 student. All rights reserved.
//

import UIKit
var pets = ["QR CODE", "Configurações", "About"]
var petsDesc = ["mais", "Teste", "Teste"]
var myIndex = 0

class TableViewController: UITableViewController {
        
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pets.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = pets[indexPath.row]
        
        return cell
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        myIndex = indexPath.row
        performSegue(withIdentifier: "segue", sender: self)
        
    }
    
}

/* Parte do view controller
 
 import UIKit
 
 class ViewController: UIViewController {
 
 @IBOutlet weak var titleLabel: UILabel!
 @IBOutlet weak var myImageView: UIImageView!
 @IBOutlet weak var descriptionLabel: UILabel!
 
 
 
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 
 titleLabel.text = pets[myIndex]
 descriptionLabel.text = petsDesc[myIndex]
 myImageView.image = UIImage(named: pets[myIndex] + ".png")
 
 }
 
 override func didReceiveMemoryWarning() {
 super.didReceiveMemoryWarning()
 // Dispose of any resources that can be recreated.
 }
 
 
 }
*/
