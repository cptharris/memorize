//
//  CardView.swift
//  Memorize
//
//  Created by Caleb Harris on 8/29/23.
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
		TimePie(endAngle: .degrees(240))
			.opacity(Constants.TimePie.opacity)
			.overlay() {
				Text(card.content)
					.font(.system(size: Constants.FontSize.largest))
					.minimumScaleFactor(Constants.FontSize.scaleFactor)
					.aspectRatio(1, contentMode: .fit)
					.multilineTextAlignment(.center)
			}
			.padding(Constants.inset)
			.cardify(isFaceUp: card.isFaceUp)
			.opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
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
