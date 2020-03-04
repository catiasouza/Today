//
//  Item.swift
//  Today01
//
//  Created by Catia Miranda de Souza on 02/03/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object{
    @objc dynamic var title : String = ""
    @objc dynamic var done = false
    @objc dynamic var dateCreated: Date? // para pesquisar por data
    var parentCategory = LinkingObjects(fromType: Category.self, property: "itens")//relacionamento inverso que vincula cada item a uma parentCategory
}
