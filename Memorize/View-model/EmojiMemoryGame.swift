//
//  EmojiMemoryGame.swift
//  Memorize - Vue-modèle
//
//  Created by Gabriel Caron on 2021-02-14.
//

import SwiftUI

// TODO les nouveaux thèmes vont venir ici

class EmojiMemoryGame: ObservableObject {
    // Private pour permettre seulement de modifier le modèle par la vue-modèle
    @Published private var model: MemoryGame<String> = EmojiMemoryGame.createMemoryGame()
    
    private static func createMemoryGame() -> MemoryGame<String> {
        let emojis: Array<String> = ["🦁", "🦄", "🐵", "🐸", "🦖", "🐿"]
        
        return MemoryGame<String>(numberOfCards: emojis.count) { pairIndex in
            return emojis[pairIndex]
        }
    }
    
    
    // MARK: - Access to the Model
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    
    // MARK: - Intent(s)
    
    func choose(card: MemoryGame<String>.Card) {
        objectWillChange.send()
        model.choose(card: card)
        if model.currentNumberOfMatchs == model.totalNumberOfMatchs {
            resetGame()
        }
    }
    
    func resetGame() {
        model = EmojiMemoryGame.createMemoryGame()
    }
}
