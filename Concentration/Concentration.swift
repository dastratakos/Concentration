//
//  Concentration.swift
//  Concentration
//
//  Created by Dean Stratakos on 3/31/20.
//  Copyright © 2020 Dean Stratakos. All rights reserved.
//

import Foundation

class Concentration {
    
    var cards = [Card]()
    private(set) var theme: Int
    private(set) var flipCount = 0
    private(set) var score = 0
    private var seenCards = [Int]()
    var usedEmojis = [Bool]()
    
    func gameOver() -> Bool {
        for index in cards.indices {
            if !cards[index].isFaceUp && !cards[index].isMatched {
                return false
            }
        }
        return true
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
        if cards[index].isMatched { return }
        if let matchIndex = indexOfOneAndOnlyFaceUpCard {
            // if the same card was pressed
            if matchIndex == index { return }
            // check if cards match
            if cards[matchIndex].identifier == cards[index].identifier {
                cards[matchIndex].isMatched = true
                cards[index].isMatched = true
                score += 2
            } else {
                if seenCards[index] == 0 {
                    seenCards[index] = 1
                } else {
                    score -= 1
                }
                if seenCards[indexOfOneAndOnlyFaceUpCard!] == 0 {
                    seenCards[indexOfOneAndOnlyFaceUpCard!] = 1
                } else {
                    score -= 1
                }
            }
            cards[index].isFaceUp = true
        } else {
            // either no cards or 2 cards are face up
            indexOfOneAndOnlyFaceUpCard = index
        }
        flipCount += 1
    }
    
    init(numberOfPairsOfCards: Int, numThemes: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        cards = cards.shuffled()
        theme = Int(arc4random_uniform(UInt32(numThemes)))
        seenCards = Array(repeating: 0, count: numberOfPairsOfCards * 2)
        usedEmojis = Array(repeating: false, count: 28)
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
