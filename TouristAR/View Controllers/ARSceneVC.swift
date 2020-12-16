//
//  ViewController.swift
//  AR-Test
//
//  Created by Zac Johnson on 9/12/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import UIKit
import SwiftUI
import SpriteKit
import ARKit
import CoreData
import CoreLocation

class ARSceneVC: UIViewController, ARSKViewDelegate, CLLocationManagerDelegate {
	
	// MARK: - Properties
	
	let locationManager = CLLocationManager()
	
	var userLocation = CLLocation()
	var sightsJSON: JSON!
	var userHeading = 0.0
	var headingCount = 0
	var pages = [UUID: Site]()
	
	// MARK: - UI Elements
	
	var menuButton: UIButton = {
		let btn = UIButton(type: .system)
		
		let image = UIImage(systemName: "paperplane")?.withRenderingMode(.alwaysTemplate)
		btn.setImage(image, for: .normal)
		btn.tintColor = .black
		btn.backgroundColor = UIColor.white.withAlphaComponent(0.7)
		btn.translatesAutoresizingMaskIntoConstraints = false
		btn.isUserInteractionEnabled = true
		btn.showsMenuAsPrimaryAction = true
		btn.addAction(UIAction(title: "", handler: { _ in
			print("Present Menu")
		}), for: .touchUpInside)
		
		return btn
	}()
    
	var sceneView: ARSKView = {
		let view = ARSKView(frame: .zero)
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
	
	var activityIndicator = UIActivityIndicatorView(style: .large)
    
	// MARK: - Lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and node count
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
		
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		
		let subViews = [sceneView, menuButton, activityIndicator]
		subViews.forEach { self.view.addSubview($0) }
		
		activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
		activityIndicator.startAnimating()
		
		requestLocationPermission()
		setSceneViewLayout()
		configureMenuButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = AROrientationTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
	
	// MARK: - Set Up Views
	
	/// Make AR SpriteKit View fill the whole screen
	private func setSceneViewLayout() {
		sceneView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		sceneView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		sceneView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		
		// Load the SKScene from 'Scene.sks'
		if let scene = SKScene(fileNamed: "Scene") {
			sceneView.presentScene(scene)
		}
	}
	
	
	/// Sets touch target for menu button and places it in bottom right corner
	private func configureMenuButton() {
		menuButton.isEnabled = false
		menuButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 12))
		menuButton.makeSquare(of: 60)
		menuButton.layer.cornerRadius = 30
		configureMenu()
	}
	
	private func configureMenu() {
		let items = UIMenu(title: "TouristAR", options: .displayInline, children: [
			UIAction(title: "Nearby Sites", image: UIImage(systemName: "list.star"), handler: { _ in
				let sites = Array(self.pages.values).sorted { (siteA, siteB) -> Bool in
					if siteA.distance != nil && siteB.distance != nil {
						return siteA.distance! < siteB.distance!
					} else {
						let locationLatA = Double(siteA.latitude) ?? 0.0
						let locationLonA = Double(siteA.longitude) ?? 0.0
						let locationA = CLLocation(latitude: locationLatA, longitude: locationLonA)
						
						let locationLatB = Double(siteB.latitude) ?? 0.0
						let locationLonB = Double(siteB.longitude) ?? 0.0
						let locationB = CLLocation(latitude: locationLatB, longitude: locationLonB)

						return Float(self.userLocation.distance(from: locationA)) < Float(self.userLocation.distance(from: locationB))
					}
				}
				
				let listVC = SiteListView(sites: sites)
				let vc = UIHostingController(rootView: listVC)
				self.present(vc, animated: true, completion: nil)
			}),
			UIAction(title: "Camera View", image: UIImage(systemName: "camera.viewfinder"), handler: { _ in })
		])
		
		menuButton.menu = UIMenu(title: "TouristAR", options: .displayInline, children: [items])
		menuButton.showsMenuAsPrimaryAction = true
		menuButton.isUserInteractionEnabled = true
	}
	
	// MARK: - Helper Methods
	
	func degreesToRadians(_ degrees: Double) -> Double {
		return degrees * .pi / 180
	}
	
	func radiansToDegrees(_ radians: Double) -> Double {
		return radians * 180 / .pi
	}
	
	func direction(from p1: CLLocation, to p2: CLLocation) -> Double {
		let lat1 = degreesToRadians(p1.coordinate.latitude)
		let lon1 = degreesToRadians(p1.coordinate.longitude)

		let lat2 = degreesToRadians(p2.coordinate.latitude)
		let lon2 = degreesToRadians(p2.coordinate.longitude)

		let lon_delta = lon2 - lon1;
		let y = sin(lon_delta) * cos(lon2)
		let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon_delta)
		let radians = atan2(y, x)
		return radiansToDegrees(radians)
	}
	
	// MARK: - Network Requests
	
	
	/// Fetch nearby locations with Wikipedia articles
	private func fetchSights() {
		let urlString = "https://en.wikipedia.org/w/api.php?ggscoord=\(userLocation.coordinate.latitude)%7C\(userLocation.coordinate.longitude)&action=query&prop=coordinates%7Cpageimages%7Cpageterms&colimit=50&piprop=thumbnail&pithumbsize=500&pilimit=50&wbptterms=description&generator=geosearch&ggsradius=10000&ggslimit=50&format=json"
		
		guard let url = URL(string: urlString) else { return }
		
		if let data = try? Data(contentsOf: url) {
			sightsJSON = JSON(data)
			locationManager.startUpdatingHeading()
			
			print(sightsJSON)
		}
	}
	
	func createSights() {
		activityIndicator.stopAnimating()
		menuButton.isEnabled = true
		// Loop through all pages in Wikipedia
		for page in sightsJSON["query"]["pages"].dictionaryValue.values {
			// Grab the coordinates and make a location
			let locationLat = page["coordinates"][0]["lat"].doubleValue
			let locationLon = page["coordinates"][0]["lon"].doubleValue
			let location = CLLocation(latitude: locationLat, longitude: locationLon)

			// Get distance in meters to user location from landmark, then calculate its azimuth
			let distance = Float(userLocation.distance(from: location))
			let azimuthFromUser = direction(from: userLocation, to: location)
			
			// Calculate angle from user to the location
			let angle = azimuthFromUser - userHeading
			let angleRadians = degreesToRadians(angle)

			// Create vertical and horizontal rotation matrices
			let rotationHorizontal = simd_float4x4(SCNMatrix4MakeRotation(Float(angleRadians), 1, 0, 0))
			let rotationVertical = simd_float4x4(SCNMatrix4MakeRotation(-0.2 + Float(distance / 6000), 0, 1, 0))

			// Combine horizonal and vertical matrices, then combine that with the camera transform
			let rotation = simd_mul(rotationHorizontal, rotationVertical)
			guard let frame = sceneView.session.currentFrame else { return }
			let rotation2 = simd_mul(frame.camera.transform, rotation)

			// Create a matrix that lets us position the anchor into the screen, then combine that
			// with our combined matrix so far
			var translation = matrix_identity_float4x4
			translation.columns.3.z = -(distance / 200)

			// Create a new anchor using the final matrix, then add it to our `pages` dictionary
			let transform = simd_mul(rotation2, translation)
			let anchor = ARAnchor(transform: transform)
			sceneView.session.add(anchor: anchor)
			
			let pageID = page["pageid"].int ?? -1
			let imageURL = page["thumbnail"]["source"].string
			let site = Site(name: page["title"].string ?? "Unknown", pageID: String(pageID), longitude: String(locationLon), latitude: String(locationLat), distance: distance, image: imageURL)
			pages[anchor.identifier] = site
		}
	}
	
	// MARK: - Permissions Requests
	
	private func requestLocationPermission() {
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.requestWhenInUseAuthorization()
	}
	    
    // MARK: - ARSKViewDelegate
    
	// Create and configure a node for the anchor added to the view's session.
	func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
		// Create and configure a node for the anchor added to the view's session.
		let labelNode = SKLabelNode(text: pages[anchor.identifier]?.name)
		labelNode.horizontalAlignmentMode = .center
		labelNode.verticalAlignmentMode = .center

		let size = labelNode.frame.size.applying(CGAffineTransform(scaleX: 1.1, y: 1.4))
		let backgroundNode = SKShapeNode(rectOf: size, cornerRadius: 10)
	
		if let site = pages[anchor.identifier] {
			let nameString = "\(site.name)|-/\(site.pageID)|-/\(site.latitude)|-/\(site.longitude)|-/\(site.image ?? "hakunamatata")"
			backgroundNode.name = nameString
			labelNode.name = nameString
		} else {
			backgroundNode.name = nil
			labelNode.name = nil
		}
	
		backgroundNode.fillColor = UIColor(hue: CGFloat.random(in: 0...1), saturation: 0.5, brightness: 0.4, alpha: 0.9)
		backgroundNode.strokeColor = backgroundNode.fillColor.withAlphaComponent(1)
		backgroundNode.lineWidth = 2
		backgroundNode.addChild(labelNode)
		return backgroundNode
	}
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
	
	
	// MARK: - CLLocationManagerDelegate
	
	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
		if status == .authorizedWhenInUse {
			locationManager.requestLocation()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
		let alert = UIAlertController(title: "Location Permission Required", message: "This app requires your location while the app is in use. Enable location in Settings > Privacy > TouristAR", preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		
		userLocation = location
		
		DispatchQueue.global().async {
			self.fetchSights()
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
		DispatchQueue.main.async {
			self.headingCount += 1
			
			// ignore the first heading update since it tends to be wildly inaccurate
			if self.headingCount != 2 {	return }
			
			self.userHeading = newHeading.magneticHeading
			
			self.locationManager.stopUpdatingHeading()
			self.createSights()
		}
	}
}

struct ARSceneVC_Previews: PreviewProvider {
	static var previews: some View {
		/*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
	}
}
