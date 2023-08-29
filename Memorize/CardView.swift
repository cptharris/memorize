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
		let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
		ZStack {
			Group {
				base.fill(.white)
				base.strokeBorder(lineWidth: Constants.lineWidth)
				Text(card.content)
					.font(.system(size: Constants.FontSize.largest))
					.minimumScaleFactor(Constants.FontSize.scaleFactor)
					.aspectRatio(1, contentMode: .fit)
					.multilineTextAlignment(.center)
			}
			.opacity(card.isFaceUp ? 1 : 0)
			base.fill().opacity(card.isFaceUp ? 0 : 1)
		}
		.opacity(card.isFaceUp || !card.isMatched ? 1 : 0)
	}
	
	private struct Constants {
		static let cornerRadius: CGFloat = 12
		static let lineWidth: CGFloat = 5
		struct FontSize {
			static let largest: CGFloat = 200
			static let smallest: CGFloat = 10
			static let scaleFactor = smallest / largest
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
