//
//  DetailInternetViewController.swift
//  MyCatsFacts
//
//  Created by Admin on 16/12/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import UIKit
import Kingfisher
import RealmSwift

class DetailViewController: UIViewController {
    
    var realm: Realm { return try! Realm() }
    var factId: String?
    var fact: Fact? = nil
    let urlApiImage = URL(string: "https://aws.random.cat/meow")!
    let LabelButton = ["Добавить в избранное","Удалить из избранного"]
    var imageUrl: String = ""
    
    @IBOutlet weak var labeltext: UILabel!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let realFactId = self.factId else {
            return
        }

        let task = URLSession.shared.dataTask(with: urlApiImage, completionHandler: handleResponse)
        task.resume()
        fact = realm.object(ofType: Fact.self, forPrimaryKey: realFactId)
        labeltext.text = fact?.text
        button.setTitle(getTitleButton(), for: .normal)
    }
    
    @IBAction func addRemoveFavourites(_ sender: Any) {
        changeToRealm()
        button.setTitle(getTitleButton(), for: .normal)
    }
    
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        do {
            let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
            imageUrl = values["file"] as! String
            print(imageUrl)


            DispatchQueue.main.async {
               self.updateImage()
           }
        } catch { print("Что-то пошло не так") }
    }
    
    func changeToRealm() {
        guard let changeFact = fact else {
            return
        }
        do {
            try realm.write {
                fact!.isFavourite = !fact!.isFavourite
                print(changeFact)
                realm.add(fact!, update: true)
            }
        } catch { print(error) }
    }
    
    func getTitleButton() -> String{
        if (fact!.isFavourite){
            return LabelButton[1]
        }
        else{
            return LabelButton[0]
        }
    }
    
    func updateImage(){
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(with: URL(string: imageUrl))
    }
    
}
