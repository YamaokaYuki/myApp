//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/03/03.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var titleId: String?

}
