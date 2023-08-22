//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Caleb Harris on 8/21/23.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
	
	/// Makes a new Memorize Game of Card Content String.
	/// The emoji set is drawn from the available themes and emojis are randomly selected.
	private static func createMemoryGame() -> MemorizeGame<String> {
		// get a random theme, protect against no themes available
		theme = MemorizeGameTheme<String>(themes.randomElement() ?? Theme("", 0, numPairs: 0, []))
		// return a new memorize game with the number of pairs and a shuffled, random selection of the available emojis
		return MemorizeGame(numberOfPairs: theme.numPairs) {
			return theme.contentSet.indices.contains($0) ? theme.contentSet[$0] : nil
		}
	}
	
	@Published private var game = createMemoryGame()
	private static var theme = MemorizeGameTheme<String>()
	
	// MARK: - Operations
	
	var themeName: String {
		EmojiMemorizeGame.theme.name.uppercased()
	}
	
	var themeColor: Color {
		Color(hue: Double(EmojiMemorizeGame.theme.hue)/360, saturation: 1, brightness: 0.8)
	}
	
	var gameScore: Int {
		game.score
	}
	
	var gameIsComplete: Bool {
		game.gameIsComplete
	}
	
	var getCards: Array<MemorizeGame<String>.Card> {
		game.cards
	}
	
	// MARK: - Intents
	
	func shuffle() {
		game.shuffle()
	}
	
	func choose(_ card: MemorizeGame<String>.Card) {
		game.choose(card)
	}
	
	func reset() {
		game = EmojiMemorizeGame.createMemoryGame()
	}
	
	// MARK: - THEME
	
	private static let themes = [
		Theme<String>("halloween", 30, numPairs: 8, ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌", "🧟"]),
		Theme<String>("christmas", 0, numPairs: 8, ["🎁", "🎄", "🎅", "🧝", "🕯️", "❄️", "⛄️", "🦌", "🛷", "🍪"]),
		Theme<String>("animals", 110, numPairs: 8, ["🐰", "🐶", "🐦", "🐧", "🦎", "🐱", "🐴", "🐟", "🐠", "🦜"])
	]
	
	class Theme<CardContent> {
		let name: String
		let hue: Int
		let numPairs: Int
		let contentSet: [CardContent]
		
		init(_ name: String, _ hue: Int, numPairs: Int, _ contentSet: [CardContent]) {
			self.name = name
			self.hue = hue
			self.numPairs = numPairs
			self.contentSet = contentSet
		}
	}
}
