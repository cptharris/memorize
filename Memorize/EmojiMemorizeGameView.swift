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
			
			ScrollView {
				cardsView
					.foregroundColor(.orange)
					.animation(.default, value: gameKeeper.getCards)
			}
			
			Button("Shuffle") {
				gameKeeper.shuffle()
			}
		}
		.padding(10)
	}
	
	var cardsView: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 80), spacing: 0)], spacing: 0) {
			ForEach(gameKeeper.getCards.indices, id: \.self) { index in
				CardView(gameKeeper.getCard(index))
					.aspectRatio(2/3, contentMode: .fit)
					.padding(2)
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
	}
}

struct EmojiMemorizeGameView_Previews: PreviewProvider {
	static var previews: some View {
		EmojiMemorizeGameView(gameKeeper: EmojiMemorizeGame())
	}
}
