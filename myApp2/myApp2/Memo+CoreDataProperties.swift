//
//  Memo+CoreDataProperties.swift
//  
//
//  Created by 山岡由季 on 2018/02/05.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var title: String?
    @NSManaged public var content: String?

}
