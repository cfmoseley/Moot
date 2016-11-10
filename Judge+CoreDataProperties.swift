//
//  Judge+CoreDataProperties.swift
//  Moot
//
//  Created by Colin Moseley on 8/22/16.
//  Copyright © 2016 Colin Moseley. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Judge {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var province: String?
    @NSManaged var frenchSpeaking: NSNumber?
    @NSManaged var city: String?

}
