//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable {
	private(set) var cards: Array<Card>
	private(set) var score = 0
	
	init(numberOfPairs: Int, cardContentFactory: (Int) -> CardContent?) {
		cards = []
		for pairIndex in 0..<max(2, numberOfPairs) {
			if let content = cardContentFactory(pairIndex) {
				cards.append(Card(content: content, id: "\(pairIndex+1)a"))
				cards.append(Card(content: content, id: "\(pairIndex+1)b"))
			} else {
				break
			}
		}
		shuffle()
	}
	
	var indexOfTheOneAndOnlyFaceUpCard: Int? {
		// get indices of cards that are face up, then get the one index if there is only one
		get { cards.indices.filter { cards[$0].isFaceUp }.only }
		// look at each card. if the new only face up card is the current card, set the current card to face up. set everything else to face down
		set { cards.indices.forEach { cards[$0].set(toFaceUp: newValue == $0) } }
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
						if !cards[chosenIndex].wasSeen && !cards[potentialMatchIndex].wasSeen {
							score += 1
						}
					} else if cards[chosenIndex].wasSeen {
						score -= 1
					}
				// if there is not a face up card yet
				} else {
					indexOfTheOneAndOnlyFaceUpCard = chosenIndex
				}
				// show the chosen card
				cards[chosenIndex].set(toFaceUp: true)
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
		
		mutating func set(toFaceUp: Bool) {
			if toFaceUp {
				isFaceUp = true
			} else {
				if isFaceUp {
					wasSeen = true
				}
				isFaceUp = false
			}
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
