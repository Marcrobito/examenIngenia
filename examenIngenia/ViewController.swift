//
//  ViewController.swift
//  examenIngenia
//
//  Created by Marco Antonio Martínez Gutiérrez on 10/05/18.
//  Copyright © 2018 Marco Antonio Martínez Gutiérrez. All rights reserved.
//

import Alamofire
import UIKit
import SwiftyJSON
import RealmSwift


class FavsCustomCell: UITableViewCell{
    
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var tweetUser: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var hashtagContainer: UITextField!
    
    let baseUrl = "https://serene-woodland-62357.herokuapp.com/twitter/"
    var hashtag : String = "Ingenia"
    var json = JSON("[]")
    //var favourites : Results<FavouritTwitter>? = nil
    let realm = try! Realm()
    //lazy var favourites: Results<FavouritTwitter> = { realm.objects(FavouritTwitter.self) }()
    
    lazy var favourites = realm.objects(FavouritTwitter.self)
   
    
    
    @IBAction func startSearch(_ sender: Any) {
        
        
        if hashtagContainer.text != ""{
            hashtag = hashtagContainer.text!
        }
        let url = baseUrl + hashtag
        Alamofire.request(url).validate().responseJSON { response in
                if response.result.isFailure{
                    return
                }
                self.json = JSON(response.result.value!)
                self.performSegue(withIdentifier: "showResult", sender: self)
                self.hashtagContainer.text = ""
        }
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        /*let realm = try! Realm()
        favourites = realm.objects(FavouritTwitter.self)*/
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // your cell coding
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngeniaCell", for: indexPath) as! FavsCustomCell
        
        cell.tweetUser.text =  favourites[indexPath.row].userName
        cell.tweetLabel.text = favourites[indexPath.row].twitterText
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showResult"){
            let viewController = segue.destination as? HashtagListViewController
            
            viewController?.json = self.json
                
            
            
        }
    }


}

