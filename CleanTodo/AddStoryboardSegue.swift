//
//  AddStoryboardSegue.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit


class AddStoryboardSegue: UIStoryboardSegue {

	override func perform() {
		let fromVC = self.sourceViewController
		let toVC = self.destinationViewController as! AddViewController
		
		let blurView = UIImageView(frame: UIScreen.mainScreen().bounds)
		blurView.alpha = 0.0
		
		UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, UIScreen.mainScreen().scale)
		fromVC.view.drawViewHierarchyInRect(UIScreen.mainScreen().bounds, afterScreenUpdates: true)
		
		let blurredImage = UIGraphicsGetImageFromCurrentImageContext()
		blurredImage.applyDarkEffect()
		
		UIGraphicsEndImageContext()
		
		blurView.image = blurredImage
		
		toVC.transitioningBackgroundView = blurView
		
	}
}
