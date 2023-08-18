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
    let emojis = ["👻", "😈", "🎃", "🕷️"]
    
    // the body is a property of the View
    // this one is a Computer Property
    var body: some View {
        HStack {
            ForEach(emojis.indices, id: \.self) { index in
                CardView(content: emojis[index])
            }
        }
        .foregroundColor(Color.purple)
        .padding()
    }
}

struct CardView: View {
    let content: String
    @State var isFaceUp = true
    
    var body: some View {
        // use let because variables in ViewBuilder do not vary
        let base = RoundedRectangle(cornerRadius: 20)
        ZStack {
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 5)
                Text(content).font(.largeTitle)
            } else {
                base
            }
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
