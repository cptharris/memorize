//
//  MemorizeApp.swift
//  Memorize
//
//  Created by Captain Harris on 8/17/23.
//

import SwiftUI

@main
struct MemorizeApp: App {
	@StateObject var game = EmojiMemorizeGame()
	var body: some Scene {
		WindowGroup {
			EmojiMemorizeGameView(gameKeeper: game)
		}
	}
}
