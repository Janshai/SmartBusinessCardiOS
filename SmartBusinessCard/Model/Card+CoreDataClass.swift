//
//  Card+CoreDataClass.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 15/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Card)
public class Card: NSManagedObject {
    
    private var context: NSManagedObjectContext?
    
    fileprivate convenience init?(name: String, operations: [CardBuildingOperations],
                                  context: NSManagedObjectContext) {
        guard let desc = NSEntityDescription.entity(forEntityName: "Card", in: context) else {
            return nil
        }
        self.init(entity: desc, insertInto: context)
        
        self.context = context
        
        self.firstName = name
        self.id = UUID()
        self.dateAdded = Date()
        
        for i in operations.indices {
    
            let operation = operations[i]
            
            switch operation {
            case .hasAddress(let address): self.address = address
            case .hasWebsite(let website): self.website = website
            case .withImage(let image): self.cardImageName = image
            case .withOtherNames(let names): self.otherNames = names
            }
        }
    
    }
    
    func delete() {
        // TODO: handle errors
        context?.delete(self)
        do {
            try(context?.save())
        }
        catch let err {
            print(err)
        }
    }
    
    
    
}

public class CardBuilder {
    
    private var operations = [CardBuildingOperations]()
    private var name: String
    private var context = CoreDataStack.stack.persistentContainer.viewContext
    
    init(withCardName name: String) {
        self.name = name
    }
    
    func build() -> Card? {
        return Card(name: name, operations: operations, context: context)
    }
    
    func add(address: String) {
        operations += [.hasAddress(address: address)]
    }
    
    func add(website: String) {
        operations += [.hasWebsite(website: website)]
    }
    
    func add(image: String) {
        operations += [.withImage(image: image)]
    }
    
    func add(otherNames names: String) {
        operations += [.withOtherNames(names: names)]
    }
    
}

fileprivate enum CardBuildingOperations {
    case hasAddress(address: String)
    case hasWebsite(website: String)
    case withImage(image: String)
    case withOtherNames(names: String)
}
