//
//  PresentationState.swift
//  Redux Presentation
//
//  Created by Daniel Tartaglia on 2/4/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//


public struct PresentationState {
	
	public init() { }
	
	public mutating func pushViewController(viewController: String) {
		viewControllerIDs.append(viewController)
	}
	
	public mutating func popViewController() {
		viewControllerIDs.popLast()
	}
	
	public mutating func popToRoot() {
		viewControllerIDs = []
	}
	
	public private (set) var viewControllerIDs: [String] = []
}
