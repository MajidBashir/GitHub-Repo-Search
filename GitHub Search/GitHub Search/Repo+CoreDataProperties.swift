//
//  Repo+CoreDataProperties.swift
//  GitHub Search
//
//  Created by Majid Bashir on 26/05/2018.
//  Copyright © 2018 Majid Bashir. All rights reserved.
//
//

import Foundation
import CoreData


extension Repo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Repo> {
        return NSFetchRequest<Repo>(entityName: "Repo")
    }

    @NSManaged public var has_wiki: Bool
    @NSManaged public var name: String?
    @NSManaged public var owner: String?
    @NSManaged public var size: Int64

}
