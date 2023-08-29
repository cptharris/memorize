//
//  MemorizeGame.swift
//  Memorize
//
//  Created by Captain Harris on 8/21/23.
//

import Foundation

struct MemorizeGame<CardContent> where CardContent: Equatable {
	private(set) var cards: Array<Card>
	private let theme: MemorizeGameTheme<CardContent>
	private(set) var score = 0
	
	init(theme: MemorizeGameTheme<CardContent>, cardContentFactory: (Int) -> CardContent?) {
		self.theme = theme
		
		cards = []
		for pairIndex in 0..<max(2, self.theme.numPairs) {
			if let content = cardContentFactory(pairIndex) {
				cards.append(Card(content: content, id: "\(pairIndex+1)a"))
				cards.append(Card(content: content, id: "\(pairIndex+1)b"))
			} else {
				break
			}
		}
		shuffle()
	}
	
	var themeName: String {
		theme.name
	}
	
	var themeHue: Double {
		theme.hue
	}
	
	private var indexOfTheOneAndOnlyFaceUpCard: Int? {
		// get indices of cards that are face up, then get the one index if there is only one
		get { cards.indices.filter { cards[$0].isFaceUp }.only }
		// look at each card. if the new only face up card is the current card, set the current card to face up. set everything else to face down
		set { cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) } }
	}
	
	var gameIsComplete: Bool {
		cards.indices.filter { !cards[$0].isMatched }.count == 0
	}
	
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
						score += 2 + cards[chosenIndex].bonus + cards[potentialMatchIndex].bonus
						if !cards[chosenIndex].wasSeen && !cards[potentialMatchIndex].wasSeen {
							score += 1
						}
					} else if cards[chosenIndex].wasSeen || cards[potentialMatchIndex].wasSeen {
						score -= 1
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
	
	private mutating func shuffle() {
		cards.shuffle()
	}
	
	// MARK: - Types
	
	/// MemorizeGame Card type which stores facts about a Card
	struct Card: Equatable, Identifiable, CustomDebugStringConvertible {
		var debugDescription: String {
			return "\(id): \(content) is face \(isFaceUp ? "up" : "down"), is \(isMatched ? "" : "un")matched, and has \(wasSeen ? "" : "not ")been seen"
		}
		
		var isFaceUp = false {
			didSet {
				if isFaceUp {
					startUsingBonusTime()
				} else {
					stopUsingBonusTime()
				}
				if oldValue && !isFaceUp {
					wasSeen = true
				}
			}
		}
		var isMatched = false {
			didSet {
				if isMatched {
					stopUsingBonusTime()
				}
			}
		}
		var wasSeen = false
		let content: CardContent
		
		var id: String
		
		// MARK: Bonus Time
		
		// call this when the card transitions to face up state
		private mutating func startUsingBonusTime() {
			if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
				lastFaceUpDate = Date()
			}
		}
		
		// call this when the card goes back face down or gets matched
		private mutating func stopUsingBonusTime() {
			pastFaceUpTime = faceUpTime
			lastFaceUpDate = nil
		}
		
		// the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
		// this gets smaller and smaller the longer the card remains face up without being matched
		var bonus: Int {
			Int(bonusTimeLimit * bonusPercentRemaining)
		}
		
		// percentage of the bonus time remaining
		var bonusPercentRemaining: Double {
			bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
		}
		
		// how long this card has ever been face up and unmatched during its lifetime
		// basically, pastFaceUpTime + time since lastFaceUpDate
		var faceUpTime: TimeInterval {
			if let lastFaceUpDate {
				return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
			} else {
				return pastFaceUpTime
			}
		}
		
		// can be zero which would mean "no bonus available" for matching this card quickly
		var bonusTimeLimit: TimeInterval = 6
		
		// the last time this card was turned face up
		var lastFaceUpDate: Date?
		
		// the accumulated time this card was face up in the past
		// (i.e. not including the current time it's been face up if it is currently so)
		var pastFaceUpTime: TimeInterval = 0
	}
}

extension Array {
	var only: Element? {
		count == 1 ? first : nil
	}
}
