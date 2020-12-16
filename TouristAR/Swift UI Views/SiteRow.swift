//
//  SiteRow.swift
//  AR-Test
//
//  Created by Zac Johnson on 12/15/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI

struct SiteRow: View {
	var site: Site
	
    var body: some View {
		HStack {
			Text(site.name).padding(.all, 10)
			Spacer()
			
			if let distance = site.distance {
				Text("\(String(format: "%.1f mi", distance / 1609))").padding(.all, 10)
			} else {
				Text("Unknown").padding(.all, 10)
			}
		}
    }
}

struct SiteRow_Previews: PreviewProvider {
    static var previews: some View {
		SiteRow(site: Site(name: "Logan Tabernacle", pageID: "26795404", longitude: "-111.83333333", latitude: "41.73222222", distance: 50.0, image: "https://www.usu.edu/today/images/stories/lg/Old-Main-Winter.jpg"))
    }
}
