//
//  ViewController.swift
//  Concentration
//
//  Created by Dean Stratakos on 3/31/20.
//  Copyright © 2020 Dean Stratakos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // this is the model, private because it depends on numberOfPairsOfCards
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards, numThemes: emojiChoices.count)
    
    // can be public because it is already read-only
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2, numThemes: emojiChoices.count)
        emoji = [Int:String]()
        flipAllCardsDown()
        updateViewFromModel()
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBOutlet private weak var scoreLabel: UILabel!
    
    @IBOutlet private weak var newGameButton: UIButton!
    
    @IBOutlet private var cardButtons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newGameButton.layer.cornerRadius = 4
        
        for button in cardButtons {
            button.layer.cornerRadius = 8
        }
    }
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            if game.gameOver() { return }
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Card not in array")
        }
    }
    
    private func flipCardUp(button: UIButton, emoji: String) {
        button.setTitle(emoji, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.setImage(nil, for: .normal)
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    private func flipCardDown(button: UIButton) {
        button.setTitle("", for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        let image = UIImage(named: "card")
        button.setImage(image, for: .normal)
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
    }
    
    private func hideCard(button: UIButton) {
        button.setTitle("", for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        button.setImage(nil, for: .normal)
        UIView.transition(with: button, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    private func flipAllCardsDown() {
        for button in cardButtons {
            flipCardDown(button: button)
        }
    }
    
    private func updateViewFromModel() {
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        let over = game.gameOver()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if over {
                flipCardUp(button: button, emoji: emoji(for: card))
            } else if card.isFaceUp && !card.wasFaceUp {
                game.cards[index].wasFaceUp = true
                flipCardUp(button: button, emoji: emoji(for: card))
            } else if !card.isFaceUp && card.wasFaceUp {
                game.cards[index].wasFaceUp = false
                if !card.isMatched {
                    flipCardDown(button: button)
                } else {
                    hideCard(button: button)
                }
            }
        }
    }
    
//    https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.pinterest.com%2Fcatcam18%2Femoji-combinations%2F&psig=AOvVaw34qclFNGb1Od52Yb9vWBug&ust=1587881355162000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOiakZ31gukCFQAAAAAdAAAAABAD
//    https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.tumblr.com%2Ftagged%2Femoji%2Baesthetic&psig=AOvVaw34qclFNGb1Od52Yb9vWBug&ust=1587881355162000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCOiakZ31gukCFQAAAAAdAAAAABAK
    
    private let emojiChoices =  [
        ["🤲🏼", "👐🏼", "🙌🏼", "👏🏼", "👍🏼", "👎🏼", "👊🏼", "✊🏼", "🤛🏼", "🤜🏼", "🤞🏼", "✌🏼", "🤟🏼", "🤘🏼", "👌🏼", "🤏🏼", "👈🏼", "👉🏼", "👆🏼", "👇🏼", "☝🏼", "✋🏼", "🤚🏼", "🖖🏼", "👋🏼", "🤙🏼", "💪🏼", "✍🏼"],
        ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🐔", "🐧", "🐦", "🐤", "🐺", "🐗", "🐴", "🦄"],
        ["🐒", "🐥", "🦆", "🦅", "🦉", "🦇", "🐢", "🐍", "🦎", "🦖", "🦕"],
//        ["🐝", "🐛", "🦋", "🐌", "🐞", "🐜", "🦟", "🦗", "🕷", "🦂"],
        ["🐙", "🦑", "🦐", "🦞", "🦀", "🐡", "🐠", "🐟", "🐬", "🐳", "🐋", "🦈"],
        ["🐊", "🐅", "🐆", "🦓", "🦍", "🦧", "🐘", "🦛", "🦏", "🐪", "🐫", "🦒", "🦘", "🐃", "🐂", "🐄", "🐎", "🐖", "🐏", "🦙", "🐐", "🦌", "🐕", "🐩", "🦮", "🐕‍🦺", "🐈"],
        ["🐓", "🦃", "🦚", "🦜", "🦢", "🦩", "🕊", "🐥", "🦆", "🦅", "🦉", "🐣"],
        ["🐇", "🦝", "🦨", "🦡", "🦦", "🦥", "🐁", "🐀", "🐿", "🦔"],
        ["🌵", "🎄", "🌲", "🌳", "🌴", "🌱", "🌿", "☘️", "🍀", "🎍", "🎋", "🍃", "🍂", "🍁", "🍄", "🌾", "💐", "🌷", "🌹", "🥀", "🌺", "🌸", "🌼", "🌻"],
        ["☀️", "⛅️", "🌧", "⛈", "🌩", "🌨", "❄️", "☔️", "☁️", "🌪"],
        ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🥏", "🎱"],
        ["❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "💖"],
//        ["0️⃣", "1️⃣", "2️⃣", "3️⃣", "4️⃣", "5️⃣", "6️⃣", "7️⃣", "8️⃣", "9️⃣"],
        ["🟥", "🟧", "🟨", "🟩", "🟦", "🟪", "⬛️", "⬜️", "🟫", "🔲"],
        ["🔘", "🔴", "🟠", "🟡", "🟢", "🔵", "🟣", "⚫️", "⚪️", "🟤"]
    ]
    
    private var emoji = [Int:String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices[game.theme].count > 0 {
            var randomIndex: Int
            repeat {
                randomIndex = emojiChoices[game.theme].count.arc4random
            } while game.usedEmojis[randomIndex]
            emoji[card.identifier] = emojiChoices[game.theme][randomIndex]
            game.usedEmojis[randomIndex] = true
        }
        return emoji[card.identifier] ?? "?"
    }
    
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
