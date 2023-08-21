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
			cards.append(Card(content: content, id: "\(pairIndex+1)a"))
			cards.append(Card(content: content, id: "\(pairIndex+1)b"))
		}
	}
	
	mutating func allFaceDown() {
		for index in cards.indices {
			cards[index].isFaceUp = false
		}
	}
	
	var indexOfTheOneAndOnlyFaceUpCard: Int? {
		get { cards.indices.filter { cards[$0].isFaceUp }.only }
		set { return cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
	}
	
	// MARK: - User Intents
	
	mutating func choose(_ card: Card) {
		// if chosen card is valid
		if let chosenIndex = cards.firstIndex(where: {$0.id == card.id}) {
			// if chosen card is not face up and not matched
			if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
				// if there is one face up card
				if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard	{
					// if the one face up card and the chosen card match
					if cards[chosenIndex].content == cards[potentialMatchIndex].content {
						cards[chosenIndex].isMatched = true
						cards[potentialMatchIndex].isMatched = true
					}
				// if there is not a face up card yet
				} else {
					indexOfTheOneAndOnlyFaceUpCard = chosenIndex
				}
				// show the chosen card
				cards[chosenIndex].isFaceUp = true
			}
		}
	}
	
	mutating func shuffle() {
		cards.shuffle()
	}
	
	// MARK: - Types
	
	/// MemorizeGame Card type which stores facts about a Card
	struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
		var debugDescription: String {
			return "\(id): \(content) face \(isFaceUp ? "up" : "down") \(isMatched ? "" : "un")matched"
		}
		
		var isFaceUp = false
		var isMatched = false
		let content: CardContent
		
		var id: String
	}
}

extension Array {
	var only: Element? {
		count == 1 ? first : nil
	}
}
