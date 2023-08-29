//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Captain Harris on 8/17/23.
//

import SwiftUI

struct EmojiMemorizeGameView: View {
	typealias Card = MemorizeGame<String>.Card
	@ObservedObject var gameKeeper: EmojiMemorizeGame
	
	var body: some View {
		VStack(spacing: 0) {
			Text("Memorize!")
				.font(.largeTitle)
			Text(gameKeeper.themeName)
				.font(.caption)
				.foregroundColor(gameKeeper.themeColor)
			
			cardsView
				.foregroundColor(gameKeeper.themeColor)
			
			HStack {
				score
				Spacer()
				newGame
			}
			.padding(.horizontal)
		}
		.padding(Constants.Padding.game)
	}
	
	private var score: some View {
		Text("Score: \(gameKeeper.score)")
			.animation(nil)
	}
	
	private var newGame: some View {
		Button("New Game") {
			// shuffling
			withAnimation {
				gameKeeper.reset()
			}
		}
		.buttonStyle(.bordered)
	}
	
	private var cardsView: some View {
		AspectVGrid(gameKeeper.getCards, aspectRatio: Constants.cardAspectRatio) { card in
			CardView(card)
				.padding(Constants.Padding.card)
				.overlay(FlyingNumber(number: scoreChange(causedBy: card)))
				.onTapGesture {
					// card choose
					withAnimation {
						gameKeeper.choose(card)
					}
				}
		}
	}
	
	private func scoreChange(causedBy card: Card) -> Int {
		return 0
	}
	
	private struct Constants {
		static let cardAspectRatio: CGFloat = 2/3
		struct Padding {
			static let game: CGFloat = 10
			static let card: CGFloat = 2
		}
	}
}

struct EmojiMemorizeGameView_Previews: PreviewProvider {
	static var previews: some View {
		EmojiMemorizeGameView(gameKeeper: EmojiMemorizeGame())
	}
}
