//
//  Card.swift
//  Concentration
//
//  Created by Boris V on 13.11.2017.
//  Copyright © 2017 GRIAL. All rights reserved.
//

import Foundation

struct Card: Hashable {
    // conform to hashable
    var hashValue: Int {
        return identifier
    }
    // conform to equatable
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    var isFaceUp = false // флаг карта лицом вверх
    var isMatched = false // флаг совпадения
    var shownFace: Bool? = nil // флаг засветки карты
    var identifier: Int
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
}
