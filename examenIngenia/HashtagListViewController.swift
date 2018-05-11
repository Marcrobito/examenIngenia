//
//  HashtagListViewController.swift
//  examenIngenia
//
//  Created by Marco Antonio Martínez Gutiérrez on 10/05/18.
//  Copyright © 2018 Marco Antonio Martínez Gutiérrez. All rights reserved.
//


import SwiftyJSON
import SwipeCellKit
import RealmSwift
import UIKit

class CustomCell: SwipeTableViewCell{
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var twetterUser: UILabel!
}

class HashtagListViewController: UITableViewController, SwipeTableViewCellDelegate {
    
    var json:JSON = JSON("[]")
    weak var delegate: ViewController!
    
    override func viewDidLoad() {
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return json.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngeniaCell", for: indexPath) as! CustomCell
        
        cell.twetterUser.text =  json[indexPath.row]["user"]["name"].string
        cell.tweetLabel.text = json[indexPath.row]["text"].string
        cell.delegate = self
        return cell
        
    }
    //IngeniaCell
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else {
            let favouriteAction = SwipeAction(style: .default, title: "Favorito"){ action, indexPath in
                let favoutire = FavouritTwitter()
                favoutire.twitterId =  self.json[indexPath.row]["id"].int!
                favoutire.twitterText = self.json[indexPath.row]["text"].string!
                favoutire.date = self.json[indexPath.row]["date"].string!
                favoutire.userTwitterId = self.json[indexPath.row]["user"]["id"].int!
                favoutire.userName = self.json[indexPath.row]["user"]["name"].string!
                favoutire.userPhotoUrl = self.json[indexPath.row]["user"]["profile_image_url"].string!
                
                let realm = try! Realm()
                try! realm.write {
                    realm.add(favoutire)
                }
                
                self.json.arrayObject?.remove(at: indexPath.row)
                self.tableView.reloadData()
                
                let alert = UIAlertController(title: "Favorito guardado", message: "El twitter se guardado en la lista de favoritos", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
            }
            return[favouriteAction]
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Borrar") { action, indexPath in
            // handle action by updating model with deletion
            self.json.arrayObject?.remove(at: indexPath.row)
            self.tableView.reloadData()
            
            let alert = UIAlertController(title: "Twitter borrado", message: "El twitter se ha borrado de la lista", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        //deleteAction.image = UIImage(named: "thrash")
        
        return [deleteAction]
    }
    
}
