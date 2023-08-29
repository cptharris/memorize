//
//  AspectVGrid.swift
//  Memorize
//
//  Created by Captain Harris on 8/23/23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
	private var items: [Item]
	private var aspectRatio: CGFloat = 1
	private var content: (Item) -> ItemView
	
	init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
		self.items = items
		self.aspectRatio = aspectRatio
		self.content = content
	}
	
	var body: some View {
		GeometryReader { geometry in
			let gridItemSize = gridItemWidthThatFits(
				count: items.count,
				size: geometry.size,
				atAspectRatio: aspectRatio
			)
			
			LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
				ForEach(items) { item in
					content(item).aspectRatio(aspectRatio, contentMode: .fit)
				}
			}
		}
	}
	
	private func gridItemWidthThatFits(count: Int, size: CGSize, atAspectRatio aspectRatio: CGFloat) -> CGFloat {
		let count = CGFloat(count)
		var columnCount = 1.0
		repeat {
			// width and height of every card, given this number of columns
			let width = size.width / columnCount
			let height = width / aspectRatio
			// number of cards divided by number of columns give number of rows
			let rowCount = (count / columnCount).rounded(.up)
			
			// if the total height fits in the alloted space, return the width
			if rowCount * height < size.height {
				return (width).rounded(.down)
			}
			// if the total height does not fit, add another column
			columnCount += 1
		} while columnCount < count
		return min(size.width / count, size.height * aspectRatio).rounded(.down)
	}
}
