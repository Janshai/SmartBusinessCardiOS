//
//  Message+CoreDataClass.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 15/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject {
    
    private static let entityName = "Message"
    
    convenience init?(card: Card, text: String, read: Bool) {
        let context = CoreDataStack.stack.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: Message.entityName, in: context) {
            self.init(entity: entity, insertInto: context)
            self.card = card
            self.text = text
            self.read = read
            self.date = Date()
            self.id = UUID()
            self.card.dateOfLastMessage = date
            
        }
        else {
            return nil
            //TODO Handle This Issue
        }
        
    }

}
