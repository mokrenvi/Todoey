//
//  Category.swift
//  Todoey
//
//  Created by Valeria Mokrenko on 8/23/18.
//  Copyright © 2018 Valeria Mokrenko. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
    
}
