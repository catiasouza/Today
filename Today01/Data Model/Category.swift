//
//  Category.swift
//  Today01
//
//  Created by Catia Miranda de Souza on 02/03/20.
//  Copyright © 2020 Catia Miranda de Souza. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let itens = List<Item>()//especifica que cada categoria pode ter um item
   
}
