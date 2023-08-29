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
		let base = RoundedRectangle(cornerRadius: 20)
		ZStack {
			Group {
				base.fill(.white)
				base.strokeBorder(lineWidth: 5)
				Text(card.content)
					.font(.system(size: 200))
					.minimumScaleFactor(0.01)
					.aspectRatio(1, contentMode: .fit)
					.multilineTextAlignment(.center)
			}
			.opacity(card.isFaceUp ? 1 : 0)
			base.fill().opacity(card.isFaceUp ? 0 : 1)
		}
		.opacity(card.isMatched ? 0 : 1)
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
