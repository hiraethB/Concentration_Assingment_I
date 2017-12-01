//
//  Concentration.swift
//  Concentration
//
//  Created by Boris V on 12.11.2017.
//  Copyright © 2017 GRIAL. All rights reserved.
//

import Foundation

struct Concentration {
    
    private(set) var cards = [Card]()
    // индекс единственной открытой карты
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter { cards[$0].isFaceUp}.oneAndOnly
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    private(set) var flipCount = 0
    private(set) var max = 0
    private var start = Date()
    
    mutating func chooseCard(at index: Int) {
        if !cards[index].isMatched {
            cards[index].shownFace != nil ? (cards[index].shownFace = true) : (cards[index].shownFace = false)
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // 2 карты лицом вверх
                if cards[matchIndex] == cards[index] {
                   // max += 2 // +2 балла за совпадение
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                  // вычисление промежутка времени c премией (до очередного соответствия)
                    let timeCutOff = Date()
                    max += 2+Int(5/timeCutOff.timeIntervalSince(start)) // премия?!
                } else { // нет совпадения, вычислить пенальти
                    if cards[index].shownFace! { // флаг засветки карты
                        max -= 1 // выбранная карта уже открывалась
                    }
                    if cards[matchIndex].shownFace! {
                        max -= 1
                    }
                }
                cards[index].isFaceUp = true
            } else { // единственная карта лицом вверх
                indexOfOneAndOnlyFaceUpCard = index
            }
            flipCount += 1
            start = Date()
        }
    }
    // заполнение массива cards = [Card]
    init(numberOfPairsOfCards: Int) {
        print(numberOfPairsOfCards) // отладка
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card,card]
        }
          cards.shuffle()
    }
    
    mutating func cardshuffle () {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].shownFace = nil
        }
        cards.shuffle()
        flipCount = 0; max = 0
    }
}
// перемешивание массива
extension MutableCollection {
    mutating func shuffle() {
        let c = count - 8 // 8 = число карт в стеках поворота
        guard c > 1 else { return }
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
}
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}


