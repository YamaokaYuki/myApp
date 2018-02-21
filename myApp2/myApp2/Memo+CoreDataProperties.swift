//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/02/20.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var orderNumber: Int64
    @NSManaged public var titleId: String?

}
