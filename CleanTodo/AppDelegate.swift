//
//  AppDelegate.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import CoreData
import Redux


@UIApplicationMain
class AppDelegate: UIResponder {

	var window: UIWindow?
	let dataStore = DataStore()
	var presentationObserver: PresentationObserver!
	var unsubscriber: AppStore.Unsubscriber!
}

extension AppDelegate: UIApplicationDelegate {

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		presentationObserver = PresentationObserver(rootViewController: window!.rootViewController!)
		unsubscriber = appStore.subscribe { [weak self] state in
			self?.presentationObserver.updateWithState(state.presentationState)
		}
		return true
	}
}

