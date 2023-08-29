//
//  FlyingNumber.swift
//  Memorize
//
//  Created by Captain Harris on 8/29/23.
//

import SwiftUI

struct FlyingNumber: View {
	let number: Int
	
	var body: some View {
		if number != 0 {
			Text(number, format: .number)
		}
	}
}

struct FlyingNumber_Previews: PreviewProvider {
	static var previews: some View {
		FlyingNumber(number: 5)
	}
}
