//
//  AddViewController.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


class AddViewController: UIViewController {
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var nameTextField: UITextField!
	
	var transitioningBackgroundView: UIView?
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		modalPresentationStyle = .Custom
		transitioningDelegate = self
	}
	
	@IBAction func cancelAction(_: AnyObject) {
		appStore.dispatch(AddAction.Canceled)
	}
	private func warnUserWithMessage(message: String) {
		let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .Alert)
		alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
		presentViewController(alert, animated: true, completion: nil)
	}
	
	private let customPresentAnimationController = AddPresentationTransition()
}

extension AddViewController: UIViewControllerTransitioningDelegate {
	
	func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return customPresentAnimationController
	}
	
	func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AddDismissalTransition()
	}
}