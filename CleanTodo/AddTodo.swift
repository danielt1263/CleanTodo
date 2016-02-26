//
//  AddTodo.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


func addTodo(viewController: UIViewController) {
	let addController = viewController.storyboard!.instantiateViewControllerWithIdentifier("AddViewController") as! AddViewController
	firstly {
		viewController.promisePresentViewController(addController, animated: true, completion: nil)
		}
		.then {
			promiseWhile({ (name, date) in name.isEmpty }, body: addController.waitForAdd) { addController.warnUserWithMessage("Name must not be empty.") }
		}
		.then { name, date in
			
			print("name: \(name), date: \(date)")
		}
		.then {
			addController.promiseDismissViewControllerAnimated(true, completion: nil)
		}
		.error { error in
			switch error {
			case AddError.AddCanceled:
				addController.promiseDismissViewControllerAnimated(true, completion: nil)
			default:
				break
			}
	}
}

private func validateName(name: String, date: NSDate) -> Bool {
	return !name.isEmpty
}


