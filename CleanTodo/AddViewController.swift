//
//  AddViewController.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


enum AddError: ErrorType {
	case AddCanceled
}

class AddViewController: UIViewController {
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var nameTextField: UITextField!
	
	weak var transitioningBackgroundView: UIView!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .Custom
		transitioningDelegate = self
	}
	
	func waitForAdd() -> Promise<(name: String, date: NSDate)>  {
		pendingAdd = Promise<(name: String, date: NSDate)>.pendingPromise()
		return pendingAdd!.promise
	}
	
	func warnUserWithMessage(message: String) -> Promise<Void> {
		return Promise { fulfill, _ in
			let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .Alert)
			alert.addAction(UIAlertAction(title: "OK", style: .Default) { _ in fulfill() })
			presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	private var pendingAdd: Promise<(name: String, date: NSDate)>.PendingPromise?
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		let recognizer = UITapGestureRecognizer(target: self, action: Selector("dismiss"))
		transitioningBackgroundView.addGestureRecognizer(recognizer)
		transitioningBackgroundView.userInteractionEnabled = true
		nameTextField.becomeFirstResponder()
	}
	
	@IBAction func cancelAction(_: AnyObject) {
		dismiss()
	}
	
	@IBAction func saveAction(_: AnyObject) {
		
		let name = nameTextField.text ?? ""
		let date = datePicker.date
		
		pendingAdd!.fulfill((name, date))
	}
	
	private func dismiss() {
		view.endEditing(true)
		pendingAdd!.reject(AddError.AddCanceled)
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