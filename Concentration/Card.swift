//
//  Card.swift
//  Concentration
//
//  Created by Dean Stratakos on 3/31/20.
//  Copyright © 2020 Dean Stratakos. All rights reserved.
//

import Foundation

struct Card {
    
    var isFaceUp = false
    var wasFaceUp = false
    var isMatched = false
    var identifier: Int
    
    private static var identifierCounter = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierCounter += 1
        return identifierCounter
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
}
