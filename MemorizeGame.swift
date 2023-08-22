//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import Foundation
import SwiftUI

struct MemorizeGame<CardContent> where CardContent: Equatable {
	let themeName: String
	let themeColor: Color
	private(set) var cards: Array<Card>
	private(set) var score = 0
	
	/// create the cards array
	/// - Parameters:
	///   - numberOfPairs: number of pairs to create in the array, enforces at least 2
	///   - cardContentFactory: function that returns CardContent values, given an index
	///   - themeName: name for the theme in use
	///   - themeColor: color for the theme in use
	init(_ themeName: String, _ themeColor: Color, numberOfPairs: Int, cardContentFactory: (Int) -> CardContent) {
		self.themeName = themeName
		self.themeColor = themeColor
		
		cards = []
		for pairIndex in 0..<max(2, numberOfPairs) {
			let content = cardContentFactory(pairIndex)
			cards.append(Card(content: content, id: "\(pairIndex+1)a"))
			cards.append(Card(content: content, id: "\(pairIndex+1)b"))
		}
		cards.shuffle()
	}
	
	var indexOfTheOneAndOnlyFaceUpCard: Int? {
		// get indices of cards that are face up, then get the one index if there is only one
		get { cards.indices.filter { cards[$0].isFaceUp }.only }
		// look at each card. if the new only face up card is the current card, set the current card to face up. set everything else to face down
		set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
	}
	
	var gameIsComplete: Bool {
		cards.indices.filter { !cards[$0].isMatched }.count == 0
	}
	
	// MARK: - Intents
	
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
						score += 2
					} else if cards[chosenIndex].wasSeen {
						score -= 1
					}
				// if there is not a face up card yet
				} else {
					indexOfTheOneAndOnlyFaceUpCard = chosenIndex
				}
				// show the chosen card
				cards[chosenIndex].show()
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
			return "\(id): \(content) is face \(isFaceUp ? "up" : "down"), is \(isMatched ? "" : "un")matched, and has \(wasSeen ? "" : "not") been seen"
		}
		
		mutating func show() {
			isFaceUp = true
			wasSeen = true
		}
		
		var isFaceUp = false
		var isMatched = false
		var wasSeen = false
		let content: CardContent
		
		var id: String
	}
}

extension Array {
	var only: Element? {
		count == 1 ? first : nil
	}
}
