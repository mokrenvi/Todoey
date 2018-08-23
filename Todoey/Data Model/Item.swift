//
//  Item.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/23/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated: Date?
    //points to forward relationship items
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
