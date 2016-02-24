//
//  PresentationStack.swift
//  Redux Presentation
//
//  Created by Daniel Tartaglia on 1/25/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit


public class PresentationObserver {
	
	public init(rootViewController: UIViewController) {
		self.rootViewController = rootViewController
	}
	
	public func updateWithState(state: PresentationState) {
		if let index = commonChildIndex(viewControllers.map { self.properName[$0.nibName!]! }, rhs: state.viewControllerIDs) {
			if state.viewControllerIDs.count == index + 1 {
				dismissAnimatedFrom(viewControllers[index])
			}
			else {
				viewControllers[index].dismissViewControllerAnimated(false, completion: nil)
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
				rootViewController.dismissViewControllerAnimated(false, completion: nil)
				loadNewViewControllersFromViewController(rootViewController, viewControllerIds: state.viewControllerIDs)
			}
		}
	}

	private func loadNewViewControllersFromViewController(baseViewController: UIViewController, viewControllerIds: [String]) {
		var presentingViewController = baseViewController
		for viewControllerId in viewControllerIds {
			if viewControllerId != viewControllerIds.last! {
				let newViewController = rootViewController.storyboard!.instantiateViewControllerWithIdentifier(viewControllerId)
				properName[newViewController.nibName!] = viewControllerId
				presentingViewController.presentViewController(newViewController, animated: false, completion: nil)
				presentingViewController = newViewController
			}
			else {
				let newViewController = rootViewController.storyboard!.instantiateViewControllerWithIdentifier(viewControllerId)
				properName[newViewController.nibName!] = viewControllerId
				presentAnimatedFrom(presentingViewController, toViewController: newViewController)
			}
		}
	}
	
	private let rootViewController: UIViewController
	private let waitForRoutingCompletionQueue = dispatch_queue_create("WaitForRoutingCompletionQueue", nil)
	
	private var properName: [String: String] = [:]
	
	private var viewControllers: [UIViewController] {
		var result: [UIViewController] = []
		var viewController = rootViewController
		while let presentedViewController = viewController.presentedViewController {
			result.append(presentedViewController)
			viewController = presentedViewController
		}
		return result
	}

	private func presentAnimatedFrom(viewController: UIViewController, toViewController: UIViewController) {
		let semaphore = dispatch_semaphore_create(0)
		dispatch_async(waitForRoutingCompletionQueue) {
			dispatch_async(dispatch_get_main_queue()) {
				viewController.presentViewController(toViewController, animated: true) {
					dispatch_semaphore_signal(semaphore)
				}
			}
			let waitUntil = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
			dispatch_semaphore_wait(semaphore, waitUntil)
		}
	}
	
	private func dismissAnimatedFrom(viewController: UIViewController) {
		let semaphore = dispatch_semaphore_create(0)
		dispatch_async(waitForRoutingCompletionQueue) {
			dispatch_async(dispatch_get_main_queue()) {
				viewController.dismissViewControllerAnimated(true) {
					dispatch_semaphore_signal(semaphore)
				}
			}
			let waitUntil = dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC)))
			dispatch_semaphore_wait(semaphore, waitUntil)
		}
	}
}

internal func commonChildIndex<T: Equatable>(lhs: [T], rhs: [T]) -> Int? {
	guard !lhs.isEmpty && !rhs.isEmpty else { return nil }
	
	for i in 0 ..< min(lhs.count, rhs.count) {
		if lhs[i] != rhs[i] {
			return i == 0 ? nil : i
		}
	}
	return min(lhs.count - 1, rhs.count - 1)
}
