//
//  Theme.swift
//  Memorize
//
//  Created by Caleb Harris on 8/22/23.
//

import Foundation

struct MemorizeGameTheme<CardContent> {
	let name: String
	let hue: Int
	let numPairs: Int
	let contentSet: [CardContent]
	
	init(_ theme: EmojiMemorizeGame.Theme<CardContent>) {
		self.name = theme.name
		self.hue = theme.hue
		self.numPairs = theme.numPairs
		self.contentSet = theme.contentSet.shuffled()
	}
	
	init() {
		self.name = ""
		self.hue = -1
		self.numPairs = -1
		self.contentSet = []
	}
}
