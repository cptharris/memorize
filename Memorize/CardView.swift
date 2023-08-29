//
//  CardView.swift
//  Memorize
//
//  Created by Captain Harris on 8/29/23.
//

import SwiftUI

/// displays a card
struct CardView: View {
	typealias Card = MemorizeGame<String>.Card
	let card: Card
	
	init(_ card: Card) {
		self.card = card
	}
	
	var body: some View {
		TimelineView(.animation(minimumInterval: 1/2)) { timeline in
			if card.isFaceUp || !card.isMatched {
				TimePie(endAngle: .degrees(card.bonusPercentRemaining * 360))
					.opacity(Constants.TimePie.opacity)
					.overlay(cardContents)
					.padding(Constants.inset)
					.cardify(isFaceUp: card.isFaceUp)
					.transition(.scale)
			} else {
				Color.clear
			}
		}
	}
	
	var cardContents: some View {
		Text(card.content)
			.font(.system(size: Constants.FontSize.largest))
			.minimumScaleFactor(Constants.FontSize.scaleFactor)
			.aspectRatio(1, contentMode: .fit)
			.multilineTextAlignment(.center)
			.rotationEffect(.degrees(card.isMatched ? 360 : 0)) // text spin
			.animation(.spin(duration: 1), value: card.isMatched)
	}
	
	private struct Constants {
		static let inset: CGFloat = 8
		struct FontSize {
			static let largest: CGFloat = 200
			static let smallest: CGFloat = 10
			static let scaleFactor = smallest / largest
		}
		struct TimePie {
			static let opacity: Double = 0.4
		}
	}
}

extension Animation {
	static func spin(duration: TimeInterval) -> Animation {
		.linear(duration: duration).repeatForever(autoreverses: false)
	}
}

struct CardView_Previews: PreviewProvider {
	typealias Card = CardView.Card
	static var previews: some View {
		VStack {
			HStack {
				CardView(Card(isFaceUp: true, content: "X", id: "test1"))
				CardView(Card(content: "X", id: "test1"))
			}
			HStack {
				CardView(Card(isFaceUp: true, isMatched: true, content: "X", id: "test1"))
				CardView(Card(isMatched: true, content: "X", id: "test1"))
			}
		}.padding().foregroundColor(.green)
	}
}
