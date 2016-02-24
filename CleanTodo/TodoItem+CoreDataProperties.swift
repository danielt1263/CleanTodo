//
//  TodoItem+CoreDataProperties.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension TodoItem {

    @NSManaged var name: String?
    @NSManaged var date: NSDate?

}
