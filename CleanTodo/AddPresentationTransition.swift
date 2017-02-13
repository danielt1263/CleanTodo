//
//  AddPresentationTransition.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/23/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit

class AddPresentationTransition: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.72
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
		let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) as! AddViewController
		
		let blurView = UIView(frame: UIScreen.main.bounds)
		blurView.backgroundColor = UIColor.black
		blurView.alpha = 0.0
				
		let containerView = transitionContext.containerView
		containerView.addSubview(blurView)
		containerView.addSubview(toVC.view)

		toVC.transitioningBackgroundView = blurView
		
		let toViewFrame = CGRect(x: 0, y: 0, width: 260.0, height: 342.0)
		toVC.view.frame = toViewFrame
		
		let finalCenter = CGPoint(x: fromVC.view.bounds.width / 2.0, y: 20.0 + toViewFrame.height / 2.0)
		toVC.view.center = CGPoint(x: finalCenter.x, y: finalCenter.y - toVC.view.bounds.height - 20)
		
		UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0.22, options: [.curveEaseIn, .allowAnimatedContent], animations: { () -> Void in
			toVC.view.center = finalCenter
			blurView.alpha = 0.7
			}, completion: { (_) -> Void in
				toVC.view.center = finalCenter
				transitionContext.completeTransition(true)
		})
	}
	
}
