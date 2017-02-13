//
//  UIViewControllerPromises.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/22/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


extension UIViewController {
	
	func present(_ viewControllerToPresent: UIViewController, animated: Bool) -> Promise<Void> {
		return Promise { fulfill, _ in
			self.present(viewControllerToPresent, animated: animated, completion: {
				fulfill()
			})
		}
	}
	
	func dismiss(animated: Bool) -> Promise<Void> {
		return Promise { fulfill, _ in
			self.dismiss(animated: animated, completion: {
				fulfill()
			})
		}
	}
}
