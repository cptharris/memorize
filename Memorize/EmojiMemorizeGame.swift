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
		// get a random theme
		let chosenTheme = themes[Int.random(in: themes.indices)]
		// get the emojiSet from the theme and shuffle it
		let emojiSet = chosenTheme.emojiSet.shuffled()
		// return a new memorize game with the theme name, color, and number of pairs
		// and a shuffled, random selection of the available emojis
		return MemorizeGame(chosenTheme.name, chosenTheme.color, numberOfPairs: chosenTheme.numPairs) {
			return emojiSet.indices.contains($0) ? emojiSet[$0] : "⚠️"
		}
	}
	
	@Published private var game = createMemoryGame()
	
	// MARK: - Operations
	
	var themeName: String {
		game.themeName
	}
	
	var themeColor: Color {
		game.themeColor
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
	
	func reset() {
		game = EmojiMemorizeGame.createMemoryGame()
	}
	
	// MARK: - THEME
	
	private static let themes = [
		Theme("halloween", Color.orange, numPairs: 8, ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌", "🧟"]),
		Theme("christmas", Color.red, numPairs: 8, ["🎁", "🎄", "🎅", "🧝", "🕯️", "❄️", "⛄️", "🦌", "🛷", "🍪"]),
		Theme("animals", Color.green, numPairs: 8, ["🐰", "🐶", "🐦", "🐧", "🦎", "🐱", "🐴", "🐟", "🐠", "🦜"])
	]
	
	/// Holds a Theme for the Memorize Game.
	/// Includes a name String, Color, number of pairs, and emoji set.
	class Theme {
		let name: String
		let color: Color
		let numPairs: Int
		let emojiSet: [String]
		
		init(_ name: String, _ color: Color, numPairs: Int, _ emojiSet: [String]) {
			self.name = name
			self.color = color
			self.numPairs = numPairs
			self.emojiSet = emojiSet
		}
	}
}
