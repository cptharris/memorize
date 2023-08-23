//
//  EmojiMemorizeGameView.swift
//  Memorize
//
//  Created by Caleb Harris on 8/17/23.
//

import SwiftUI

struct EmojiMemorizeGameView: View {
	@ObservedObject var gameKeeper: EmojiMemorizeGame
	
	private let cardAspectRatio: CGFloat = 2/3
	
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
	
	private var lowerPanelView: some View {
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
	
	private var cardsView: some View {
		GeometryReader { geometry in
			let gridItemSize = gridItemWidthThatFits(
				count: gameKeeper.getCards.count,
				size: geometry.size,
				atAspectRatio: cardAspectRatio)
			
			LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
				ForEach(gameKeeper.getCards) { card in
					CardView(card)
						.aspectRatio(cardAspectRatio, contentMode: .fit)
						.padding(2)
						.onTapGesture {
							gameKeeper.choose(card)
						}
				}
			}
		}
	}
	
	private func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
		let count = CGFloat(count)
		var columnCount = 1.0
		repeat {
			// width and height of every card, given this number of columns
			let width = size.width / columnCount
			let height = width / aspectRatio
			// number of cards divided by number of columns give number of rows
			let rowCount = (count / columnCount).rounded(.up)
			
			// if the total height fits in the alloted space, return the width
			if rowCount * height < size.height {
				return (width).rounded(.down)
			}
			// if the total height does not fit, add another column
			columnCount += 1
		} while columnCount < count
		return min(size.width / Double(count), size.height * aspectRatio).rounded(.down)
	}
}

/// displays a card
private struct CardView: View {
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
