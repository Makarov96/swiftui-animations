//
//  CrediCardViewModel.swift
//  animations
//
//  Created by Guerin Steven Colocho Chacon on 6/04/25.
//

import SwiftUI

@Observable
class CreditCardViewModel {
    var cards: [CreditCardModel] = []
    var currentIndex: Int
    var currentCard: CreditCardModel
    var selectedStyleIndices: [String: Int] = [:]
    var currentStyleIndex: Int {
        get {
            return selectedStyleIndices[currentCard.id] ?? 0
        }
        set {
            selectedStyleIndices[currentCard.id] = newValue
        }
    }
    
    var currentStyle: CardStyleOption {
        get {
            let styleIndex = currentStyleIndex
            if styleIndex < currentCard.backgroundStyleOptions.count {
                return currentCard.backgroundStyleOptions[styleIndex]
            }
            return CardStyleOption.normal(color: .gray)
        }
    }
    
    init(
        cards: [CreditCardModel] = mockCreditCards,
        initialColorIndex: Int = 0,
        initialIndex: Int = 0
    ) {
        self.cards = cards
        self.currentIndex = initialIndex
        self.currentCard = cards[initialIndex]
        
        for card in cards {
            selectedStyleIndices[card.id] = 0
        }
    }
    
    func cardStyle(at index: Int) -> CardStyleOption {
        let card = cards[index]
        let styleIndex = selectedStyleIndices[card.id] ?? 0
        
        if styleIndex < card.backgroundStyleOptions.count && !card.backgroundStyleOptions.isEmpty {
            return card.backgroundStyleOptions[styleIndex]
        }
        return CardStyleOption.normal(color: .gray)
    }
    
    func selectCard(at index: Int) {
        guard index >= 0, index < cards.count else { return }
        currentIndex = index
        currentCard = cards[currentIndex]
    }
    
    func selectStyle(at index: Int) {
        guard index >= 0 && index < currentCard.backgroundStyleOptions.count else { return }
        currentStyleIndex = index
    }
}
