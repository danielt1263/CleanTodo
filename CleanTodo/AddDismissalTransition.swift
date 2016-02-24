//
//  AddDismissalTransition.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/24/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit

class AddDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
		return 0.72
	}
	
	func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! AddViewController
		let toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

		let finalCenter = CGPoint(x: toVC.view.bounds.width / 2.0, y: (fromVC.view.bounds.height / 2.0) - fromVC.view.bounds.height - 20.0)
		let blurView = fromVC.transitioningBackgroundView
		UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0.22, options: [.CurveEaseIn, .AllowAnimatedContent], animations: { () -> Void in
			fromVC.view.center = finalCenter
			blurView.alpha = 0
			}, completion: { _ in
				fromVC.view.removeFromSuperview()
				transitionContext.completeTransition(true)
		})
	}
}
