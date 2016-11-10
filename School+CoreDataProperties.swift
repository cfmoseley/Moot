//
//  School+CoreDataProperties.swift
//  Moot
//
//  Created by Colin Moseley on 8/23/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension School {

    @NSManaged var city: String?
    @NSManaged var name: String?
    @NSManaged var province: String?
    @NSManaged var mooters: NSSet?

}
