//
//  PromiseKitAdditions.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/25/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import PromiseKit


extension Promise {
	typealias PendingPromise = (promise: Promise<T>, fulfill: (T) -> Void, reject: (ErrorType) -> Void)
}

func promiseWhile<T>(pred: (T) -> Bool, body: () -> Promise<T>, fail: (() -> Promise<Void>)? = nil) -> Promise<T> {
	return Promise { fulfill, reject in
		func loop() {
			body().then { (t) -> Void in
				if !pred(t) {
					fulfill(t)
				}
				else {
					if let fail = fail {
						fail().then {
							loop()
						}
						.error { reject($0) }
					}
					else {
						loop()
					}
				}
			}
			.error { reject($0) }
		}
		loop()
	}
}
