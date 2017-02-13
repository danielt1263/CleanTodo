//
//  PresentationStack.swift
//  Redux Presentation
//
//  Created by Daniel Tartaglia on 1/25/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit


open class PresentationObserver {
	
	public init(rootViewController: UIViewController) {
		self.rootViewController = rootViewController
	}
	
	open func updateWithState(_ state: PresentationState) {
		if let index = commonChildIndex(viewControllers.map { self.properName[$0.nibName!]! }, rhs: state.viewControllerIDs) {
			if state.viewControllerIDs.count == index + 1 {
				dismissAnimatedFrom(viewControllers[index])
			}
			else {
				viewControllers[index].dismiss(animated: false, completion: nil)
				loadNewViewControllersFromViewController(viewControllers[index], viewControllerIds: Array(state.viewControllerIDs[index + 1 ..< state.viewControllerIDs.count]))
			}
		}
		else {
			if state.viewControllerIDs.count == 0 {
				if rootViewController.presentedViewController != nil {
					dismissAnimatedFrom(rootViewController)
				}
			}
			else {
				rootViewController.dismiss(animated: false, completion: nil)
				loadNewViewControllersFromViewController(rootViewController, viewControllerIds: state.viewControllerIDs)
			}
		}
	}

	fileprivate func loadNewViewControllersFromViewController(_ baseViewController: UIViewController, viewControllerIds: [String]) {
		var presentingViewController = baseViewController
		for viewControllerId in viewControllerIds {
			if viewControllerId != viewControllerIds.last! {
				let newViewController = rootViewController.storyboard!.instantiateViewController(withIdentifier: viewControllerId)
				properName[newViewController.nibName!] = viewControllerId
				presentingViewController.present(newViewController, animated: false, completion: nil)
				presentingViewController = newViewController
			}
			else {
				let newViewController = rootViewController.storyboard!.instantiateViewController(withIdentifier: viewControllerId)
				properName[newViewController.nibName!] = viewControllerId
				presentAnimatedFrom(presentingViewController, toViewController: newViewController)
			}
		}
	}
	
	fileprivate let rootViewController: UIViewController
	fileprivate let waitForRoutingCompletionQueue = DispatchQueue(label: "WaitForRoutingCompletionQueue", attributes: [])
	
	fileprivate var properName: [String: String] = [:]
	
	fileprivate var viewControllers: [UIViewController] {
		var result: [UIViewController] = []
		var viewController = rootViewController
		while let presentedViewController = viewController.presentedViewController {
			result.append(presentedViewController)
			viewController = presentedViewController
		}
		return result
	}

	fileprivate func presentAnimatedFrom(_ viewController: UIViewController, toViewController: UIViewController) {
		let semaphore = DispatchSemaphore(value: 0)
		waitForRoutingCompletionQueue.async {
			DispatchQueue.main.async {
				viewController.present(toViewController, animated: true) {
					semaphore.signal()
				}
			}
			let waitUntil = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			semaphore.wait(timeout: waitUntil)
		}
	}
	
	fileprivate func dismissAnimatedFrom(_ viewController: UIViewController) {
		let semaphore = DispatchSemaphore(value: 0)
		waitForRoutingCompletionQueue.async {
			DispatchQueue.main.async {
				viewController.dismiss(animated: true) {
					semaphore.signal()
				}
			}
			let waitUntil = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
			semaphore.wait(timeout: waitUntil)
		}
	}
}

internal func commonChildIndex<T: Equatable>(_ lhs: [T], rhs: [T]) -> Int? {
	guard !lhs.isEmpty && !rhs.isEmpty else { return nil }
	
	for i in 0 ..< min(lhs.count, rhs.count) {
		if lhs[i] != rhs[i] {
			return i == 0 ? nil : i
		}
	}
	return min(lhs.count - 1, rhs.count - 1)
}
