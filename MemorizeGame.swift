//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable {
	private(set) var cards: Array<Card>
	
	/// create the cards array
	/// - Parameters:
	///   - numberOfPairs: number of pairs to create in the array, enforces at least 2
	///   - cardContentFactory: function that returns CardContent values, given an index
	init(numberOfPairs: Int, cardContentFactory: (Int) -> CardContent) {
		cards = []
		for pairIndex in 0..<max(2, numberOfPairs) {
			let content = cardContentFactory(pairIndex)
			cards.append(Card(content: content))
			cards.append(Card(content: content))
		}
	}
	
	// MARK: - User Intents
	
	func choose(_ card: Card) {
		
	}
	
	mutating func shuffle() {
		cards.shuffle()
	}
	
	// MARK: - Types
	
	/// MemorizeGame Card type which stores facts about a Card
	struct Card: Equatable {
		var isFaceUp = true
		var isMatched = false
		let content: CardContent
	}
}
