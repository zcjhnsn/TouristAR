//
//  MapView.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/14/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI
import MapKit

struct MapView: View {
	var coordinate: CLLocationCoordinate2D
	@State private var region = MKCoordinateRegion()

	var body: some View {
		Map(coordinateRegion: $region)
			.onAppear {
				setRegion(coordinate)
			}
	}

	private func setRegion(_ coordinate: CLLocationCoordinate2D) {
		region = MKCoordinateRegion(
			center: coordinate,
			span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
		)
	}
}

struct MapView_Previews: PreviewProvider {
	static var previews: some View {
		MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
	}
}
