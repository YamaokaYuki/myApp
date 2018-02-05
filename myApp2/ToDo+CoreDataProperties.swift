//
//  ToDo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/02/05.
//
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var memo: String?
    @NSManaged public var title: String?
    @NSManaged public var saveDate: NSDate?
    @NSManaged public var priority: String?
    @NSManaged public var dueDate: NSDate?

}
