//
//  SiteDetailView.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/15/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI
import CoreLocation

struct SiteDetailView: View {
	var site: Site
	@Environment(\.openURL) var openURL

	var body: some View {
		
		ScrollView {
			var loc = CLLocation(latitude: Double(site.latitude) ?? 0.0, longitude: Double(site.longitude) ?? 0.0)
			MapView(coordinate: loc.coordinate)
				.ignoresSafeArea(edges: .top)
				.frame(height: 300)

			if site.image != nil {
				RemoteImage(url: site.image!)
					.scaledToFit()
					.frame(width: 300)
					.offset(y: -130)
					.padding(.bottom, -130)
					.padding([.leading, .trailing], 20)
			} else {
				CircleImage()
					scaledToFit()
					.frame(width: 300)
					.offset(y: -130)
					.padding(.bottom, -130)
					.padding([.leading, .trailing], 20)
			}
			

			VStack(alignment: .leading) {
				Text(site.name)
					.font(.title)
					.foregroundColor(.primary)


				Divider()

				if let distance = site.distance {
					Text("\(String(format: "%.1f mi", distance / 1609))")
						.font(.title2)
				}
				
				Link("Learn More", destination: URL(string: "https://en.wikipedia.org/wiki?curid=\(site.pageID)")!).padding([.top, .bottom], 10)
				
				Button(action: {
					openURL(URL(string: "https://maps.apple.com/?daddr=\(site.latitude),\(site.longitude)")!)
				}) {
					HStack(spacing: 10) {
						Image(systemName: "map.fill")
						Text("Get directions in Apple Maps")
					}
					.padding(.all, 10)
					.background(Color.green)
					.accentColor(.white)
					.cornerRadius(8)
				}
			}
			.padding()

		}
		.navigationTitle(site.name)
		.navigationBarTitleDisplayMode(.inline)
	}
}

struct SiteDetailView_Previews: PreviewProvider {
	static var previews: some View {
		SiteDetailView(site: Site(name: "Testing", pageID: "123", longitude: "-111.81416667000001", latitude: "41.740833330000001", distance: 500, image: nil))
	}
}
