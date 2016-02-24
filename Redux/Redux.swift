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


public class Store<State> {
	
	public typealias Observer = (state: State) -> Void
	public typealias Unsubscriber = () -> Void
	public typealias Reducer = (inout state: State, action: Action) -> Void
	public typealias Dispatcher = (action: Action) -> Void
	public typealias Middleware = (next: Dispatcher, state: () -> State) -> Dispatcher
	
	public init(state: State, reducer: Reducer, middleware: [Middleware] = []) {
		currentState = state
		self.reducer = reducer
		dispatcher = middleware.reverse().reduce(self._dispatch) { (dispatcher: Dispatcher, middleware: Middleware) -> Dispatcher in
			middleware(next: dispatcher, state: { self.currentState })
		}
	}
	
	public func dispatch(action: Action) {
		self.dispatcher(action: action)
	}
	
	public func subscribe(observer: Observer) -> Unsubscriber {
		let id = uniqueId++
		subscribers[id] = observer
		let dispose = { [weak self] () -> Void in
			self?.subscribers.removeValueForKey(id)
		}
		observer(state: currentState)
		return dispose
	}
	
	private func _dispatch(action: Action) {
		guard !isDispatching else { fatalError("Cannot dispatch in the middle of a dispatch") }
		isDispatching = true
		reducer(state: &currentState, action: action)
		for subscriber in subscribers.values {
			subscriber(state: currentState)
		}
		isDispatching = false
	}
	
	private var isDispatching = false
	private var currentState: State
	private var uniqueId = 0
	private var reducer: Reducer
	private var subscribers: [Int: Observer] = [:]
	private var dispatcher: Dispatcher = { _ in }
}
