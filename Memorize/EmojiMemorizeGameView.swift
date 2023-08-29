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
				deck
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
			dealt = Set<Card.ID>()
			lastScoreChange = (0, causedByCardId: "")
		}
		.buttonStyle(.bordered)
	}
	
	private var cardsView: some View {
		AspectVGrid(gameKeeper.getCards, aspectRatio: Constants.cardAspectRatio) { card in
			if isDealt(card) {
				CardView(card)
					.padding(Constants.Padding.card)
					.overlay(FlyingNumber(number: scoreChange(causedBy: card)))
					.zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0) // put on top
					.onTapGesture {
						choose(card)
					}
					.matchedGeometryEffect(id: card.id, in: dealingNamespace)
					.transition(.asymmetric(insertion: .identity, removal: .identity))
			}
		}
	}
	
	@State private var dealt = Set<Card.ID>()
	
	private func isDealt(_ card: Card) -> Bool {
		dealt.contains(card.id)
	}
	
	private var undealtCards: [Card] {
		gameKeeper.getCards.filter {!isDealt($0)}
	}
	
	@Namespace private var dealingNamespace
	
	private var deck: some View {
		ZStack {
			ForEach(undealtCards) { card in
				CardView(card)
					.matchedGeometryEffect(id: card.id, in: dealingNamespace)
					.transition(.asymmetric(insertion: .identity, removal: .identity))
					.foregroundColor(gameKeeper.themeColor)
			}
		}
		.frame(width: Constants.deckWidth, height: Constants.deckWidth / Constants.cardAspectRatio)
		.onTapGesture {
			deal()
		}
	}
	
	private func deal() {
		// deal the cards
		var delay: TimeInterval = 0
		for card in gameKeeper.getCards {
			withAnimation(Constants.Deal.animation.delay(delay)) {
				_ = dealt.insert(card.id)
			}
			delay += Constants.Deal.interval
		}
	}
	
	private func choose(_ card: Card) {
		withAnimation {
			let scoreBefore = gameKeeper.score
			gameKeeper.choose(card)
			lastScoreChange = (gameKeeper.score - scoreBefore, card.id)
		}
	}
	
	@State private var lastScoreChange = (0, causedByCardId: "")
	
	private func scoreChange(causedBy card: Card) -> Int {
		let (amount, id) = lastScoreChange
		return card.id == id ? amount : 0
	}
	
	private struct Constants {
		static let cardAspectRatio: CGFloat = 2/3
		static let deckWidth: CGFloat = 50
		struct Deal {
			static let animation: Animation = .easeInOut(duration: 1)
			static let interval: TimeInterval = 0.15
		}
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
