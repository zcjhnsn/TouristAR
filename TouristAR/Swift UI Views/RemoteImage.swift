//
//  RemoteImage.swift
//  AR-Test
//
//  Created by Zac Johnson on 11/14/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SwiftUI

struct RemoteImage: View {
	private enum LoadState {
		case loading, success, failure
	}

	private class Loader: ObservableObject {
		var data = Data()
		var state = LoadState.loading

		init(url: String) {
			guard let parsedURL = URL(string: url) else {
				fatalError("Invalid URL: \(url)")
			}

			URLSession.shared.dataTask(with: parsedURL) { data, response, error in
				if let data = data, data.count > 0 {
					self.data = data
					self.state = .success
				} else {
					self.state = .failure
				}

				DispatchQueue.main.async {
					self.objectWillChange.send()
				}
			}.resume()
		}
	}

	@StateObject private var loader: Loader
	var loading: Image
	var failure: Image

	var body: some View {
		selectImage()
			.clipShape(Circle())
			.overlay(Circle().stroke(Color.white, lineWidth: 4))
			.shadow(radius: 7)
	}

	init(url: String, loading: Image = Image(systemName: "photo"), failure: Image = Image(systemName: "multiply.circle")) {
		_loader = StateObject(wrappedValue: Loader(url: url))
		self.loading = loading
		self.failure = failure
	}

	private func selectImage() -> Image {
		switch loader.state {
		case .loading:
			return loading
		case .failure:
			return failure
		default:
			if let image = UIImage(data: loader.data) {
				return Image(uiImage: image).resizable()
			} else {
				return failure
			}
		}
	}
}

struct RemoteImage_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
