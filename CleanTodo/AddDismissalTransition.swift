//
//  AddDismissalTransition.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/24/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit

class AddDismissalTransition: NSObject, UIViewControllerAnimatedTransitioning {
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.72
	}
	
	func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
		let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) as! AddViewController
		let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!

		let finalCenter = CGPoint(x: toVC.view.bounds.width / 2.0, y: (fromVC.view.bounds.height / 2.0) - fromVC.view.bounds.height - 20.0)
		let blurView = fromVC.transitioningBackgroundView
		UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.64, initialSpringVelocity: 0.22, options: [.curveEaseIn, .allowAnimatedContent], animations: { () -> Void in
			fromVC.view.center = finalCenter
			blurView?.alpha = 0
			}, completion: { _ in
				fromVC.view.removeFromSuperview()
				transitionContext.completeTransition(true)
		})
	}
}
