//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
	typealias Card = MemorizeGame<String>.Card
	
	@Published private var game = createMemoryGame()
	
	/// Makes a new Memorize Game of Card Content String.
	/// The emoji set is drawn from the available themes and emojis are randomly selected.
	private static func createMemoryGame() -> MemorizeGame<String> {
		// get a random theme, protect against no themes available
		let theme = Constants.themes.randomElement() ?? MemorizeGameTheme()
		// return a new memorize game with the number of pairs and a shuffled, random selection of the available emojis
		return MemorizeGame(theme: theme) {
			return theme.contentSet.indices.contains($0) ? theme.contentSet[$0] : nil
		}
	}
	
	// MARK: - Operations
	
	var themeName: String {
		game.themeName.uppercased()
	}
	
	var themeColor: Color {
		Color(hue: game.themeHue/Constants.maxHue, saturation: Constants.saturation, brightness: Constants.brightness)
	}
	
	var gameScore: Int {
		game.score
	}
	
	var gameIsComplete: Bool {
		game.gameIsComplete
	}
	
	var getCards: Array<Card> {
		game.cards
	}
	
	// MARK: - Intents
	
	func choose(_ card: Card) {
		game.choose(card)
	}
	
	func reset() {
		game = EmojiMemorizeGame.createMemoryGame()
	}
	
	private struct Constants {
		static let maxHue: Double = 360
		static let saturation: Double = 1
		static let brightness: Double = 0.8
		
		private static let numPairs: Int = 8
		static let themes = [
			MemorizeGameTheme<String>("halloween", 30, numPairs: numPairs, ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌", "🧟"]),
			MemorizeGameTheme<String>("christmas", 0, numPairs: numPairs, ["🎁", "🎄", "🎅", "🧝", "🕯️", "❄️", "⛄️", "🦌", "🛷", "🍪"]),
			MemorizeGameTheme<String>("animals", 110, numPairs: numPairs, ["🐰", "🐶", "🐦", "🐧", "🦎", "🐱", "🐴", "🐟", "🐠", "🦜"])
		]
	}
}
