//
//  Fact.swift
//  MyCatsFacts
//
//  Created by Admin on 16/12/2018.
//  Copyright © 2018 Alexey. All rights reserved.
//

import Foundation
import RealmSwift

class Fact: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var text: String = ""
    @objc dynamic var isFavourite: Bool = false
    
    func decode(from dictionary: Dictionary<String, Any>) {
        id = dictionary["_id"]! as! String
        text = dictionary["text"]! as! String        
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
