//
//  Numbers+Extension.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/14/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import Foundation

extension Float {
	
	func round(toPlaces places: Int) -> Float {
		let p = log10(abs(self))
		let f = pow(10, p.rounded() - Float(places) + 1)
		let rnum = (self / f).rounded() * f
		
		return rnum
	}
}

extension Double {
	func round(toPlaces places: Int) -> Double {
		let p = log10(abs(self))
		let f = pow(10, p.rounded() - Double(places) + 1)
		let rnum = (self / f).rounded() * f
		
		return rnum
	}
}
