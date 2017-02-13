//
//  AddViewController.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


enum AddError: Error {
	case addCanceled
}

class AddViewController: UIViewController {
	
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var nameTextField: UITextField!
	
	weak var transitioningBackgroundView: UIView!
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		modalPresentationStyle = .custom
		transitioningDelegate = self
	}
	
	func waitForAdd() -> Promise<(name: String, date: Date)>  {
		pendingAdd = Promise<(name: String, date: Date)>.pending()
		return pendingAdd!.promise
	}
	
	func warnUserWithMessage(_ message: String) -> Promise<Void> {
		return Promise { fulfill, _ in
			let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in fulfill() })
			present(alert, animated: true, completion: nil)
		}
	}
	
	fileprivate var pendingAdd: Promise<(name: String, date: Date)>.PendingTuple?
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		let recognizer = UITapGestureRecognizer(target: self, action: Selector(("dismiss")))
		transitioningBackgroundView.addGestureRecognizer(recognizer)
		transitioningBackgroundView.isUserInteractionEnabled = true
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
	
	fileprivate func dismiss() {
		view.endEditing(true)
		pendingAdd!.reject(AddError.addCanceled)
	}
	
	fileprivate let customPresentAnimationController = AddPresentationTransition()
}

extension AddViewController: UIViewControllerTransitioningDelegate {
	
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return customPresentAnimationController
	}
	
	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		return AddDismissalTransition()
	}
}
