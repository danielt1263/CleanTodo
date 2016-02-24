//
//  AddTodo.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation
import Redux


enum AddAction: Action {
	case TapAddButton
	case Canceled
}


func addReducer(inout state: AppState, action: Action) {
	if let addAction = action as? AddAction {
		switch addAction {
		case .TapAddButton:
			state.presentationState.pushViewController("AddViewController")
		case .Canceled:
			state.presentationState.popViewController()
		}
	}
}