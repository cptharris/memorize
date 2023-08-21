//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
	private static let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌", "🧟"]
	
	private static func createMemoryGame() -> MemorizeGame<String> {
		return MemorizeGame(numberOfPairs: 10) { pairIndex in
			if emojis.indices.contains(pairIndex) {
				return emojis[pairIndex]
			} else {
				return "😬‼"
			}
		}
	}
	
	@Published private var game = createMemoryGame()
	
	// MARK: - Gets
	
	var getCards: Array<MemorizeGame<String>.Card> {
		game.cards
	}
	
	func getCard(_ index: Int) -> MemorizeGame<String>.Card {
		game.cards[index]
	}
	
	// MARK: - Intents
	
	func shuffle() {
		game.shuffle()
	}
	
	func choose(_ card: MemorizeGame<String>.Card) {
		game.choose(card)
	}
}
