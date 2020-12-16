//
//  AutoLayout+Extensions.swift
//  AR-Test
//
//  Created by Zac Johnson on 9/13/20.
//  Copyright © 2020 Zac Johnson. All rights reserved.
//

import UIKit

// MARK: - UIView Extension for Auto Layout
extension UIView {
	
	/// Makes view able to use AutoLayout
	func usesAutoLayout() {
		translatesAutoresizingMaskIntoConstraints = false
	}
	
	/// Helper method to make a child view fill its superview
	func fillSuperview() {
		anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
	}
	
	/// Helper method to anchor the size of a view to another view's size
	///
	/// - Parameter view: view whose size will be matched
	func anchorSize(to view: UIView) {
		widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
	}
	
	
	/// Place view in center of another view
	///
	/// - Parameter view: "container" view
	func anchorCenter(to view: UIView) {
		centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
	
	func makeSquare(of size: CGFloat) {
		heightAnchor.constraint(equalToConstant: size).isActive = true
		widthAnchor.constraint(equalToConstant: size).isActive = true
	}
	
	/// Helper function for setting AutoLayout constraints programmatically
	///
	/// - Parameters:
	///   - top: top anchor
	///   - leading: leading anchor
	///   - bottom: bottom anchor
	///   - trailing: trailing anchor
	///   - padding: padding value (.init())
	///   - size: size value (.init())
	func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
		
		if let top = top {
			topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
		}
		
		if let leading = leading {
			leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
		}
		
		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
		}
		
		if let trailing = trailing {
			trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
		}
		
		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
		
		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}
	}
}
