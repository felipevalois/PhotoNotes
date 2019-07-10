//
//  PhotoNote+CoreDataProperties.swift
//  PhotoNotes
//
//  Created by Felipe Costa on 7/5/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//
//

import Foundation
import CoreData


extension PhotoNote {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PhotoNote> {
        return NSFetchRequest<PhotoNote>(entityName: "PhotoNote")
    }

    @NSManaged public var content: String?
    @NSManaged public var name: String?
    @NSManaged public var rawDate: NSDate?
    @NSManaged public var rawImage: NSData?

}
