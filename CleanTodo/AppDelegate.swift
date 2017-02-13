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
}

extension AppDelegate: UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		
		return true
	}
}

