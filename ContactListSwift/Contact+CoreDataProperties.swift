//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Celes Augustus on 3/25/24.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var address: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var cell: String?
    @NSManaged public var city: String?
    @NSManaged public var contact: String?
    @NSManaged public var home: String?
    @NSManaged public var mail: String?
    @NSManaged public var state: String?
    @NSManaged public var zip: String?

}

extension Contact : Identifiable {

}
