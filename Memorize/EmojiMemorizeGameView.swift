//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Caleb Harris on 8/17/23.
//

import SwiftUI

struct EmojiMemorizeGameView: View {
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
				.animation(.default, value: gameKeeper.getCards)
			
			lowerPanelView
				.padding(.horizontal)
		}
		.padding(Constants.Padding.game)
	}
	
	private var lowerPanelView: some View {
		ViewThatFits {
			HStack {
				Text("Score: \(gameKeeper.gameScore)").opacity(0)
				Spacer()
				Button("New Game") {
					gameKeeper.reset()
				}
				Spacer()
				Text("Score: \(gameKeeper.gameScore)")
			}
			VStack {
				Button("New Game") {
					gameKeeper.reset()
				}
				Text("Score: \(gameKeeper.gameScore)")
			}
		}
	}
	
	private var cardsView: some View {
		AspectVGrid(gameKeeper.getCards, aspectRatio: Constants.cardAspectRatio) { card in
			CardView(card)
				.padding(Constants.Padding.card)
				.onTapGesture {
					gameKeeper.choose(card)
				}
		}
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
