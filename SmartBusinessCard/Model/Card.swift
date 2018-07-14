//
//  CardPresentation.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 14/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//

import Foundation

class Card {
    var cardImageName: String?
    var firstName: String
    var otherNames: String?
    var website: URL?
    var address: String?
    var dateAdded: Date
    var messages = [Message]()
    
    init(firstName: String, otherNames: String? = nil, cardImageName: String? = nil, website: URL? = nil, address: String? = nil, dateAdded: Date? = nil)
    {
        self.firstName = firstName
        self.otherNames = otherNames
        self.cardImageName = cardImageName
        self.website = website
        self.address = address
        self.dateAdded = dateAdded ?? Date()
    }
}
