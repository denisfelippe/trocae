//
//  Games.swift
//  trocae
//
//  Created by Usuário Convidado on 09/05/15.
//  Copyright (c) 2015 Intrare Web. All rights reserved.
//

import Foundation
import CoreData

class Games: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var console: String
    @NSManaged var image: String

}
