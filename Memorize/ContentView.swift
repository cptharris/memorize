//
//  ContentView.swift
//  Memorize
//
//  Created by Caleb Harris on 8/17/23.
//

import SwiftUI

// ": View" means "behaves like a View"
struct ContentView: View {
    // the body is a property of the View
    // this one is a Computer Property
    var body: some View {
        HStack {
            CardView(isFaceUp: true)
            CardView()
            CardView()
            CardView()
        }
        .foregroundColor(Color.purple)
        .padding()
    }
}

struct CardView: View {
    @State var isFaceUp = false
    
    var body: some View {
        // use let because variables in ViewBuilder do not vary
        let base = RoundedRectangle(cornerRadius: 20)
        ZStack {
            if isFaceUp {
                base.fill(.white)
                base.strokeBorder(lineWidth: 5)
                Text("👻").font(.largeTitle)
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
