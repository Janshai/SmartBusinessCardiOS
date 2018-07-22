//
//  Message+CoreDataProperties.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 21/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var date: Date
    @NSManaged public var id: UUID
    @NSManaged public var text: String
    @NSManaged public var read: Bool
    @NSManaged public var card: Card

}
