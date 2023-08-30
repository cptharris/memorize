//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by Captain Harris on 8/21/23.
//

import SwiftUI

class EmojiMemorizeGame: ObservableObject {
	typealias Card = MemorizeGame<String>.Card
	
	@Published private var game = createMemoryGame()
	
	private static func createMemoryGame() -> MemorizeGame<String> {
		let theme = Constants.themes.randomElement() ?? MemorizeGameTheme()
		let contentSet = theme.contentSet.shuffled()
		return MemorizeGame(theme: theme) {
			return contentSet.indices.contains($0) ? contentSet[$0] : nil
		}
	}
	
	var themeName: String {
		game.themeName.uppercased()
	}
	
	var themeColor: Color {
		Color(hue: game.themeHue/Constants.maxHue, saturation: Constants.saturation, brightness: Constants.brightness)
	}
	
	var score: Int {
		game.score
	}
	
	var cards: Array<Card> {
		game.cards
	}
	
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
