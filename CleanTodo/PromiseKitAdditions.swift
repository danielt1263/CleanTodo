//
//  PromiseKitAdditions.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/25/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import PromiseKit


func promiseWhile<T>(_ pred: @escaping (T) -> Bool, body: @escaping () -> Promise<T>, fail: (() -> Promise<Void>)? = nil) -> Promise<T> {
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
						.catch { reject($0) }
					}
					else {
						loop()
					}
				}
			}
			.catch { reject($0) }
		}
		loop()
	}
}
