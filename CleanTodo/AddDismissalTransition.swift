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
		
		let finalCenter = CGPoint(x: 160.0, y: (fromVC.view.bounds.height / 2.0) - 1000.0)
		
		UIView.animateWithDuration(self.transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0.22, options: [.CurveEaseIn, .AllowAnimatedContent], animations: { () -> Void in
			fromVC.view.center = finalCenter
			fromVC.transitioningBackgroundView?.alpha = 0
			}, completion: { _ in
				fromVC.view.removeFromSuperview()
				transitionContext.completeTransition(true)
		})
	}
}
