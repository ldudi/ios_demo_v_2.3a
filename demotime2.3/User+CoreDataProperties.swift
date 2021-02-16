//
//  User+CoreDataProperties.swift
//  demotime2.3
//
//  Created by Kapil Dev on 15/02/21.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var gender: String?
    @NSManaged public var country: String?
    @NSManaged public var state: String?
    @NSManaged public var hometown: String?
    @NSManaged public var telephone: String?
    @NSManaged public var mobile: String?
    @NSManaged public var time: Date?
    @NSManaged public var dob: Date?
    @NSManaged public var image: Data?

}

extension User : Identifiable {

}
