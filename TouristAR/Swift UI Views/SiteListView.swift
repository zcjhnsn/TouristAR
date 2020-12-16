//
//  SiteListView.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/15/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI

struct SiteListView: View {
	var sites: [Site]
    var body: some View {
		NavigationView {
			List(sites, id: \.pageID) { site in
				NavigationLink(destination: SiteDetailView(site: site)) {
					SiteRow(site: site)
				}
			}
			.navigationTitle("Nearby Sites")
		}
    }
}

struct SiteListView_Previews: PreviewProvider {
    static var previews: some View {
		SiteListView(sites: [Site(name: "Old Main (Utah State University)", pageID: "26350339", longitude: "-111.81416667000001", latitude: "41.740833330000001", distance: 500, image: nil)])
    }
}
