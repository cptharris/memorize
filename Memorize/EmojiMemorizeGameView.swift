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
		VStack {
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
		.padding(10)
	}
	
	var lowerPanelView: some View {
		HStack {
			Text("Score: \(gameKeeper.gameScore)").opacity(0)
			Spacer()
			Button("New Game") {
				gameKeeper.reset()
			}
			Spacer()
			Text("Score: \(gameKeeper.gameScore)")
		}
	}
	
	var cardsView: some View {
		ScrollView {
			LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
				ForEach(gameKeeper.getCards) { card in
					CardView(card)
						.aspectRatio(2/3, contentMode: .fit)
						.padding(2)
						.onTapGesture {
							gameKeeper.choose(card)
						}
				}
			}
		}
	}
}

/// displays a card
struct CardView: View {
	let card: MemorizeGame<String>.Card
	
	init(_ card: MemorizeGame<String>.Card) {
		self.card = card
	}
	
	var body: some View {
		let base = RoundedRectangle(cornerRadius: 20)
		ZStack {
			Group {
				base.fill(.white)
				base.strokeBorder(lineWidth: 5)
				Text(card.content)
					.font(.system(size: 200))
					.minimumScaleFactor(0.01)
					.aspectRatio(1, contentMode: .fit)
			}
			.opacity(card.isFaceUp ? 1 : 0)
			base.fill().opacity(card.isFaceUp ? 0 : 1)
		}
		.opacity(card.isMatched ? 0 : 1)
	}
}

struct EmojiMemorizeGameView_Previews: PreviewProvider {
	static var previews: some View {
		EmojiMemorizeGameView(gameKeeper: EmojiMemorizeGame())
	}
}
