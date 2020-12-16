//
//  CircleImage.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/14/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
	var body: some View {
		Image(systemName: "photo")
			.resizable()
			.background(Color.blue)
			.clipShape(Circle())
			.overlay(Circle().stroke(Color.white, lineWidth: 4))
			.shadow(radius: 7)
			
	}
}

struct CircleImage_Previews: PreviewProvider {
	static var previews: some View {
		CircleImage()
	}
}
