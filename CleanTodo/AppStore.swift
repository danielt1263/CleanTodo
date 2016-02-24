//
//  AppStore.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/23/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation
import Redux


struct AppState {
	
	var presentationState = PresentationState()
}

typealias AppStore = Store<AppState>

func reducer(inout state: AppState, action: Action) {
	addReducer(&state, action: action)
}

let appStore = AppStore(state: AppState(), reducer: reducer)
