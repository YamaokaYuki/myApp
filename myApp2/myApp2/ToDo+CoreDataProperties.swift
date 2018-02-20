//
//  ToDo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/02/19.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var dueDate: NSDate?
    @NSManaged public var id: String?
    @NSManaged public var priority: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?

}
