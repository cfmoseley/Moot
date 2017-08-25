//
//  Mooter+CoreDataProperties.swift
//  Moot
//
//  Created by Colin Moseley on 8/25/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Mooter {

    @NSManaged var firstName: String?
    @NSManaged var language: String?
    @NSManaged var lastName: String?
    @NSManaged var needsII: NSNumber?
    @NSManaged var rank: NSNumber?
    @NSManaged var side: String?
    @NSManaged var school: School?

}
