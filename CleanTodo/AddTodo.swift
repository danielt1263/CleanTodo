//
//  AddTodo.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


func addTodo(_ viewController: UIViewController) {
	let addController = viewController.storyboard!.instantiateViewController(withIdentifier: "AddViewController") as! AddViewController
	firstly {
		viewController.present(addController, animated: true)
	}
	.then {
		promiseWhile({ (name, date) in name.isEmpty }, body: addController.waitForAdd) { addController.warnUserWithMessage("Name must not be empty.") }
	}
	.then { name, date in
		
		print("name: \(name), date: \(date)")
	}
	.then {
		addController.dismiss(animated: true)
	}
	.catch { error in
		switch error {
		case AddError.addCanceled:
			let _ = addController.dismiss(animated: true)
		default:
			break
		}
	}
}

private func validateName(_ name: String, date: Date) -> Bool {
	return !name.isEmpty
}


