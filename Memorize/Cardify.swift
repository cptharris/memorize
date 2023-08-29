//
//  Cardify.swift
//  Memorize
//
//  Created by Caleb Harris on 8/29/23.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
	init(isFaceUp: Bool) {
		rotation = isFaceUp ? 0 : 180
	}
	
	var isFaceUp: Bool {
		rotation < 90
	}
	
	var rotation: Double
	var animatableData: Double {
		get { rotation }
		set { rotation = newValue }
	}
	
	func body(content: Content) -> some View {
		let base = RoundedRectangle(cornerRadius: Constants.cornerRadius)
		ZStack {
			base.strokeBorder(lineWidth: Constants.lineWidth)
				.background(base.fill(.white))
				.overlay(content)
				.opacity(isFaceUp ? 1 : 0)
			base.fill()
				.opacity(isFaceUp ? 0 : 1)
		}
		.rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
	}
	
	private struct Constants {
		static let cornerRadius: CGFloat = 12
		static let lineWidth: CGFloat = 5
	}
}

extension View {
	func cardify(isFaceUp: Bool) -> some View {
		modifier(Cardify(isFaceUp: isFaceUp))
	}
}
