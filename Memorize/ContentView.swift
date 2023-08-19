//
//  ContentView.swift
//  Memorize
//
//  Created by Caleb Harris on 8/17/23.
//

import SwiftUI

// ": View" means "behaves like a View"
struct ContentView: View {
	// ': Array<String>' or '[String]'
	let emojis = [
		[["halloween", "🎃"], ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌", "🧟"]],
		[["christmas", "🎁"], ["🎁", "🎄", "🎅", "🧝", "🕯️", "❄️", "⛄️", "🦌", "🛷", "🍪"]],
		[["animals", "🐰"], ["🐰", "🐶", "🐦", "🐧", "🦎", "🐱", "🐴", "🐟", "🐠", "🦜"]]
	]
	let themeColors = [Color.orange, Color.blue, Color.green]
	@State var currentSet = ["👻", "🕸️", "🧟", "🕷️", "🧌", "🧌", "🕸️", "💀", "👹", "👻", "👹", "🧟", "😈", "😈", "🕷️", "💀"]
	@State var emojiSet = -1
	
	var body: some View {
		VStack {
			Text("Memorize!")
				.font(.largeTitle)
			
			if emojiSet != -1 {
				ScrollView {
					cards
						.foregroundColor(themeColors[emojiSet])
				}
			} else {
				emojiSelect
					.imageScale(.large)
					.font(.largeTitle)
					.foregroundColor(.accentColor)
			}
		}
		.padding(10)
	}
	
	var emojiSelect: some View {
		HStack {
			ForEach(0..<emojis.count, id: \.self) { index in
				Button(action: {
					emojiSet = index
					// get the selected emoji set and shuffle them
					currentSet = shuffledSet()
				}, label: {
					VStack {
						Text(emojis[index][0][1])
							.font(.title)
						Text(emojis[index][0][0])
							.font(.caption2)
					}
				})
			}
		}
	}
	
	func shuffledSet() -> [String] {
		var newSet = emojis[emojiSet][1].shuffled()
		while newSet.count > 8 {
			newSet.removeFirst()
		}
		return (newSet + newSet).shuffled()
	}
	
	var cards: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 70))]) {
			ForEach(0..<currentSet.count, id: \.self) { index in
				CardView(content: currentSet[index])
					.aspectRatio(2/3, contentMode: .fit)
			}
		}
	}
}

//class theme {
//	var name: String
//	var symbol: String
//	var color: Color = .accentColor
//	var emojiSet: [String]
//
//	init(name: String, symbol: String, color: Color, emojiSet: [String]) {
//		self.name = name
//		self.symbol = symbol
//		self.color = color
//		self.emojiSet = emojiSet
//	}
//}

struct CardView: View {
	let content: String
	@State var isFaceUp = false
	
	var body: some View {
		// use let because variables in ViewBuilder do not vary
		let base = RoundedRectangle(cornerRadius: 20)
		ZStack {
			Group {
				base.fill(.white)
				base.strokeBorder(lineWidth: 5)
				Text(content).font(.largeTitle)
			}
			.opacity(isFaceUp ? 1 : 0)
			base.fill().opacity(isFaceUp ? 0 : 1)
		}
		.onTapGesture {
			isFaceUp.toggle()
		}
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView()
	}
}
