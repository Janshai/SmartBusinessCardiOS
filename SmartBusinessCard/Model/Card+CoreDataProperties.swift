//
//  Card+CoreDataProperties.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 21/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var address: String?
    @NSManaged public var cardImageName: String?
    @NSManaged public var dateAdded: Date
    @NSManaged public var firstName: String
    @NSManaged public var id: UUID
    @NSManaged public var otherNames: String?
    @NSManaged public var website: String?
    @NSManaged public var dateOfLastMessage: Date?
    @NSManaged public var messages: Set<Message>

}

// MARK: Generated accessors for messages
extension Card {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
