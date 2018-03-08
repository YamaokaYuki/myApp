//
//  ToDo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/03/07.
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
    @NSManaged public var priority: Int16
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var check: Int16

}
