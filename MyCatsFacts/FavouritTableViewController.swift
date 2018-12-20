//
//  FavouritTableViewController.swift
//  MyCatsFacts
//
//  Created by Admin on 19/12/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritTableViewController: UITableViewController {
    var selectedFactId: String?
    var realm: Realm { return try! Realm() }
    
    lazy var favFacts = realm.objects(Fact.self).filter("isFavourite == \(true)")
    override func viewDidLoad() {
        super.viewDidLoad()
        print("FavouritTableViewController")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favFacts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else {
            return
        }
        vc.factId = selectedFactId
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactCell", for: indexPath)
        
        cell.textLabel?.text = favFacts[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFact = favFacts[indexPath.row]
        selectedFactId = selectedFact.id
        performSegue(withIdentifier: "GoToViewControllerFav", sender: self)
    }


}
