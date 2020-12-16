//
//  SiteDetailVC.swift
//  AR-Test
//
//  Created by Zac Johnson on 12/15/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import Foundation

//
//  ViewController.swift
//  AR-Test
//
//  Created by Zac Johnson on 9/12/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import UIKit
import CoreLocation

class SiteDetailVC: UIViewController {
	
	// MARK: - Properties
	
	var site: Site!

	// MARK: - UI Elements
	
	
	
	var testLabel: UILabel = {
		let lbl = UILabel()
		
		lbl.translatesAutoresizingMaskIntoConstraints = false
		lbl.textAlignment = .center
		lbl.numberOfLines = 0
		
		return lbl
	}()
	
	
	// MARK: - Lifecycle
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		setUpViews()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		
	}
	
	
	// MARK: - Set Up Views
	
	func setUpViews() {
		view.backgroundColor = .systemBackground
		
		testLabel.text = "\(site.name)\n\(site.pageID)\n\(site.latitude), \(site.longitude)"
		self.view.addSubview(testLabel)
		
		testLabel.fillSuperview()
	}
	
	
	// MARK: - Helper Methods
	
	
	
	// MARK: - Network Requests
	
	
	
	
	
	/*
	private func createSights() {
		// 1: Loop over all pages from Wikipedia
		for page in sightsJSON["query"]["pages"].dictionaryValue.values {
			// 2: Pull out this page's coordinates and make a location from them
			let locationLat = page["coordinates"][0]["lat"].doubleValue
			let locationLon = page["coordinates"][0]["lon"].doubleValue
			let location = CLLocation(latitude: locationLat, longitude: locationLon)
			
			// 3: Calculate distance from user to this point then calculate its azimuth
			let distance = Float(userLocation.distance(from: location))
			let azimuthFromUser = direction(from: userLocation, to: location)
			
			// 4: Claculate the angle from the user to that direction
			let angle = azimuthFromUser - userHeading
			let angleRadians = degreesToRadians(angle)
			
			// 5: Create a horizontal rotation matrix
			let rotationHorizontal = simd_float4x4(SCNMatrix4MakeRotation(Float(angleRadians), 1, 0, 0))
			
			// 6: Create a vertical rotation matrix
			let rotationVertical = simd_float4x4(SCNMatrix4MakeRotation(-0.2 + Float(distance / 6000), 0, 1, 0))
			
			// 7: Combine horizonal and vertical matrices, then combine that with the camera transform
			let rotation = simd_mul(rotationHorizontal, rotationVertical)
			guard let sceneView = self.view as? ARSKView else { return }
			guard let frame = sceneView.session.currentFrame else { return }
			let rotation2 = simd_mul(frame.camera.transform, rotation)
			
			// 8: Create a matrix that lets us position the anchor into the screen, then combine that
			//    with our combined matrix so far
			var translation = matrix_identity_float4x4
			translation.columns.3.z = -(distance / 200)
			let transform = simd_mul(rotation2, translation)
			
			// Create a new anchor using the final matrix, then add it to our `pages` dictionary
			let anchor = ARAnchor(transform: transform)
			sceneView.session.add(anchor: anchor)
			pages[anchor.identifier] = page["title"].string ?? "Unknown"
		}
	}
	*/
	
	// MARK: - Permissions Requests
	
	
	// MARK: - Actions
	
}
