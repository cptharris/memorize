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
    let emojis = ["👻", "😈", "🎃", "🕷️", "💀", "🕸️", "🙀", "👹", "🧌"]
    @State var cardCount = 4

    var body: some View {
        VStack {
			ScrollView {
				cards.foregroundColor(.purple)
			}
			Spacer()
            cardCountAdjust
            .imageScale(.large)
            .font(.largeTitle)
            .foregroundColor(.accentColor)
            .padding()
        }
        .padding()
    }

    var cards: some View {
		LazyVGrid(columns: [GridItem(.adaptive(minimum: 120))]) {
            ForEach(0..<cardCount, id: \.self) { index in
                CardView(content: emojis[index])
					.aspectRatio(2/3, contentMode: .fit)
            }
        }
    }

    var cardCountAdjust: some View {
        HStack {
			cardRemover
            Spacer()
            cardAdder
        }
    }
	
	func cardCountAdjuster(by offset: Int, symbol: String) -> some View {
		Button(action: {
			cardCount += offset
		}, label: {
			Image(systemName: symbol + ".square")
		})
		.disabled(cardCount + offset < 1 || cardCount + offset > emojis.count)
	}

    var cardRemover: some View {
        return cardCountAdjuster(by: -1, symbol: "minus")
    }

    var cardAdder: some View {
        return cardCountAdjuster(by: +1, symbol: "plus")
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true

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
