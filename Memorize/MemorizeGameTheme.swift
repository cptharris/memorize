//
//  Theme.swift
//  Memorize
//
//  Created by Caleb Harris on 8/22/23.
//

struct MemorizeGameTheme<CardContent> {
	let name: String
	let hue: Double
	let numPairs: Int
	let contentSet: [CardContent]
	
	init(_ name: String = "", _ hue: Double = -1, numPairs: Int = -1, _ contentSet: [CardContent] = []) {
		self.name = name
		self.hue = hue
		self.numPairs = numPairs
		self.contentSet = contentSet.shuffled()
	}
}
