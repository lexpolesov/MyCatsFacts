//
//  InternetTableViewController.swift
//  MyCatsFacts
//
//  Created by Admin on 16/12/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import UIKit
import RealmSwift

class InternetTableViewController: UITableViewController {
    
    var selectedFactId: String?
    
    var realm: Realm { return try! Realm() }
    
    lazy var facts = realm.objects(Fact.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: "https://cat-fact.herokuapp.com/facts")!
        let task = URLSession.shared.dataTask(with: url, completionHandler: handleResponse)
        task.resume()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        do {
            let values = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
            let jsonFacts = values["all"] as! Array<Any>
            let newFacts = mapFacts(jsonFacts: jsonFacts)
            
            DispatchQueue.main.async {
                for newFact in newFacts{
                    let checkFact = self.realm.object(ofType: Fact.self, forPrimaryKey: newFact.id)?.isFavourite
                    if (checkFact != nil){
                        newFact.isFavourite = checkFact!
                    }
                }
                self.addToRealm(facts: newFacts)
                self.tableView.reloadData()
            }
        } catch { print("Что-то пошло не так") }
    }
    
    func mapFacts(jsonFacts: Array<Any>) -> [Fact] {
        var facts = Array<Fact>()
        for jsonFact in jsonFacts {
            let fact = Fact()
            fact.decode(from: jsonFact as! Dictionary<String, Any>)
            facts.append(fact)
        }
        return facts
    }
    
    func addToRealm(facts: [Fact]) {
        do {
            try realm.write {
                realm.add(facts, update: true)
            }
        } catch { print(error) }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? DetailViewController else {
            return
        }
        vc.factId = selectedFactId

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FactCell", for: indexPath)
        
        cell.textLabel?.text = facts[indexPath.row].text
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFact = facts[indexPath.row]
        selectedFactId = selectedFact.id
        performSegue(withIdentifier: "GoToViewController", sender: self)
    }
    
}

