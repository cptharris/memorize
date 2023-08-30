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
			
			cards
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
	
	/// Show all cards in an AspectVGrid
	private var cards: some View {
		AspectVGrid(gameKeeper.cards, aspectRatio: Constants.cardAspectRatio) { card in
			if isDealt(card) {
				CardViewEffect(card)
					.padding(Constants.Padding.card)
					.overlay(FlyingNumber(number: scoreChange(causedBy: card)))
					.zIndex(scoreChange(causedBy: card) != 0 ? 1 : 0) // put on top
					.onTapGesture {
						choose(card)
					}
			}
		}
	}
	
	/// CardView with card deal effect
	private func CardViewEffect(_ card: Card) -> some View {
		CardView(card)
			.matchedGeometryEffect(id: card.id, in: dealingNamespace)
			.transition(.asymmetric(insertion: .identity, removal: .identity))
	}
	
	// MARK: - Choosing Cards
	
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
	
	// MARK: - Dealing from Deck
	
	@State private var dealt = Set<Card.ID>()
	
	private func isDealt(_ card: Card) -> Bool {
		dealt.contains(card.id)
	}
	
	private var undealtCards: [Card] {
		gameKeeper.cards.filter { !isDealt($0) }
	}
	
	@Namespace private var dealingNamespace
	
	private var deck: some View {
		ZStack {
			ForEach(undealtCards) { card in
				CardViewEffect(card)
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
		for card in gameKeeper.cards {
			withAnimation(Constants.Deal.animation.delay(delay)) {
				_ = dealt.insert(card.id)
			}
			delay += Constants.Deal.interval
		}
	}
	
	// MARK: - Constants
	
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
