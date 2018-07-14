//
//  Message.swift
//  SmartBusinessCard
//
//  Created by Jack Adams on 14/07/2018.
//  Copyright © 2018 Jack Adams. All rights reserved.
//

import Foundation

class Message {
    var text: String
    var date: Date
    var card: Card
    
    init(text: String, card: Card, date: Date? = nil)
    {
        self.text = text
        self.card = card
        self.date = date ?? Date()
    }
}
