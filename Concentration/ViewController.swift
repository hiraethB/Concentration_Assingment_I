//
//  ViewController.swift
//  Concentration
//
//  Created by Boris V on 12.11.2017.
//  Copyright © 2017 GRIAL. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var numberOfPairsOfCards: Int {
        return (visibleButtons.count + 1) / 2
    }

    private lazy var game = Concentration( numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var themes: [ String: ( String, backGroundColor: UIColor, cardBackColor: UIColor)] = [
        "🦇🕯🙀😈🎃👻🍭🎁🦉🔮🦄👣" : ("Halloween", #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)),
        "⚽️🏀🏈⚾️🏓🏹⛳️🏸🏒🥌🎾🥊" : ("Sport", #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1), #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
        "🛴🚲🛵✈️⛵️🚁🏎🚕🚜🚠🚃🛶" : ("Transport", #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)),
        "🍎🍍🍇🍉🍒🍐🥑🍋🥥🍏🥝🍑" : ("Fruit", #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1), #colorLiteral(red: 0.9994240403, green: 0.9855536819, blue: 0, alpha: 1)),
        "🦅🐧🐄🐶🐴🦆🦕🐿🦔🐫🦃🐗" : ("Animal", #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)),
        "⛑🎓🎩🧢👑👒👮‍♂️💂‍♂️👨‍🍳👨‍🚒👩‍🎓🕵️‍♂️" : ("Cap", #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)),
        "🗝🎈⏰☎️⌛️⛱🥁🎧🏺✂️🔌📡" : ("Thing", #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)),
        "♈️♉️♊️♋️♌️♍️♎️♏️♐️♑️♒️♓️" : ("Symbol", #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1), #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1))
    ]
    
    private var emojiChoices = ""
    private var keys : [ String] {
        return Array(themes.keys)
    }
    private var randomIndexTheme = 0 {
        didSet { emojiChoices = keys[randomIndexTheme]}
    }
   //  дополнительная инициализация
    override func viewDidLoad() {
        super.viewDidLoad()
        setThemeColor()
        updateViewFromModel()
    }
    
    private func setThemeColor() {
        randomIndexTheme = Array( themes.keys).count.arc4random
        if let b = themes[keys[randomIndexTheme]]?.backGroundColor,
            let c = themes[keys[randomIndexTheme]]?.cardBackColor {
            view.backgroundColor = b
            flipCountLabel.textColor = c
            flipCountLabel.backgroundColor = b
            maxLabel.textColor = c
            maxLabel.backgroundColor = b
            reset.backgroundColor = b
        }
        updateViewFromModel()
    }
    
    private var emoji = [Card: String]()
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex,
                                                       offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String( emojiChoices.remove(at: randomStringIndex))
        }
        return emoji[card] ?? "?"
    }

    @IBOutlet private weak var maxLabel: UILabel!
    @IBOutlet private weak var flipCountLabel: UILabel!
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = visibleButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    @IBOutlet private var cardButtons: [UIButton]!
    // Hints from professor (Lection 10)
    private var visibleButtons: [UIButton]! {
        return cardButtons?.filter { !$0.superview!.isHidden }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateViewFromModel()
    }

     func updateViewFromModel() { // визуализация
         // ?увеличенное числоо кнопок на их количество в стеках поворота
         for index in visibleButtons.indices {
            let button = visibleButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji( for: card), for: .normal)
                button.backgroundColor = themes[keys[randomIndexTheme]]!.backGroundColor//.white
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? .clear : themes[keys[randomIndexTheme]]!.cardBackColor
            }
        }
        flipCountLabel.text = "Flips:\(game.flipCount)"
        maxLabel.text = "Max:\(game.max)"
        }
    
    @IBOutlet private weak var reset: UIButton!
    @IBAction private func newGame() {
        emoji = [:]
        game.cardshuffle()
        setThemeColor()
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


