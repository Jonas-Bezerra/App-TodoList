//
//  Category.swift
//  Lista
//
//  Created by jonas junior on 05/01/22.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
