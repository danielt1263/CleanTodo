//
//  Redux.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/23/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation


public protocol Action {
	
}


open class Store<State> {
	
	public typealias Observer = (_ state: State) -> Void
	public typealias Unsubscriber = () -> Void
	public typealias Reducer = (_ state: inout State, _ action: Action) -> Void
	public typealias Dispatcher = (_ action: Action) -> Void
	public typealias Middleware = (_ next: Dispatcher, _ state: () -> State) -> Dispatcher
	
	public init(state: State, reducer: @escaping Reducer, middleware: [Middleware] = []) {
		currentState = state
		self.reducer = reducer
		dispatcher = middleware.reversed().reduce(self._dispatch) { (dispatcher: Dispatcher, middleware: Middleware) -> Dispatcher in
			middleware(dispatcher, { self.currentState })
		}
	}
	
	open func dispatch(_ action: Action) {
		self.dispatcher(action)
	}
	
	open func subscribe(_ observer: @escaping Observer) -> Unsubscriber {
		let id = uniqueId + 1
		uniqueId = id
		subscribers[id] = observer
		let dispose = { [weak self] () -> Void in
			self?.subscribers.removeValue(forKey: id)
		}
		observer(currentState)
		return dispose
	}
	
	fileprivate func _dispatch(_ action: Action) {
		guard !isDispatching else { fatalError("Cannot dispatch in the middle of a dispatch") }
		isDispatching = true
		reducer(&currentState, action)
		for subscriber in subscribers.values {
			subscriber(currentState)
		}
		isDispatching = false
	}
	
	fileprivate var isDispatching = false
	fileprivate var currentState: State
	fileprivate var uniqueId = 0
	fileprivate var reducer: Reducer
	fileprivate var subscribers: [Int: Observer] = [:]
	fileprivate var dispatcher: Dispatcher = { _ in }
}
