//
//  Scene.swift
//  AR-Test
//
//  Created by Zac Johnson on 9/12/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import SpriteKit
import SwiftUI
import ARKit

protocol SceneHandler {
	func siteTapped(site: Site)
}

class Scene: SKScene {
	
	var json: JSON!
	var sceneHandler: SceneHandler?
	    
    override func didMove(to view: SKView) {
        // Setup your scene here
    }
	
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		let touch:UITouch = touches.first! as UITouch
		let positionInScene = touch.location(in: self)
		let touchedNode = self.atPoint(positionInScene)
		
		if let name = touchedNode.name {
			print("\(name) Touched")
			let components = name.components(separatedBy: "|-/")
			
			guard components.count == 5 else { return }
			
			var detailVC = SiteDetailVC()
			detailVC.site = Site(name: components[0], pageID: components[1], longitude: components[3], latitude: components[2], distance: nil, image: components[4])
			
			let menuVC = SiteDetailView(site: detailVC.site)
			let vc = UIHostingController(rootView: menuVC)
			
			
			self.view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
			//sceneHandler?.siteTapped(site: )
		} else { print("Other place touched")}
		
		
    }
}
