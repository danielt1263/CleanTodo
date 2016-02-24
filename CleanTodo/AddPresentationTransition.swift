//
//  AddPresentationTransition.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/23/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit

class AddPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.72
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
		let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! AddViewController
		
		let blurView = UIView(frame: UIScreen.mainScreen().bounds)
		blurView.backgroundColor = UIColor.blackColor()
		blurView.alpha = 0.0
				
		let containerView = transitionContext.containerView()
		containerView?.addSubview(blurView)
		containerView?.addSubview(toVC.view)

		toVC.transitioningBackgroundView = blurView
		
		let toViewFrame = CGRect(x: 0, y: 0, width: 260.0, height: 342.0)
		toVC.view.frame = toViewFrame
		
		let finalCenter = CGPoint(x: fromVC.view.bounds.width / 2.0, y: 20.0 + toViewFrame.height / 2.0)
		toVC.view.center = CGPoint(x: finalCenter.x, y: finalCenter.y - toVC.view.bounds.height - 20)
		
		UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0.22, options: [.CurveEaseIn, .AllowAnimatedContent], animations: { () -> Void in
			toVC.view.center = finalCenter
			blurView.alpha = 0.7
			}, completion: { (_) -> Void in
				toVC.view.center = finalCenter
				transitionContext.completeTransition(true)
		})
	}
	
}
