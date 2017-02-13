//
//  NSCalendarAdditions.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation


extension Calendar {
	
	func dateForEndOfDay(_ date: Date) -> Date {
		var dayComponent = DateComponents()
		dayComponent.day = 1
		let nextDay = self.date(byAdding: dayComponent, to: dateForBeginningOfDay(date))!
		return nextDay.addingTimeInterval(-1)
	}
	
	func dateForEndOfFollowingWeekWithDate(_ date: Date) -> Date {
		let endOfWeek = dateForEndOfWeekWithDate(date)
		var nextWeekComponent = DateComponents()
		nextWeekComponent.weekOfYear = 1
		return self.date(byAdding: nextWeekComponent, to: endOfWeek)!
	}

	func dateForBeginningOfDay(_ date: Date) -> Date {
		let components = (self as NSCalendar).components([.year, .month, .day], from: date)
		return self.date(from: components)!
	}
	
	func dateForEndOfWeekWithDate(_ date: Date) -> Date {
		let daysRemainingThisWeek = daysRemainingInWeekWithDate(date)
		var remainingDaysComponent = DateComponents()
		remainingDaysComponent.day = daysRemainingThisWeek
		return self.date(byAdding: remainingDaysComponent, to: date)!
	}
	
	func daysRemainingInWeekWithDate(_ date: Date) -> Int {
		let weekdayComponent = dateComponents([.weekday], from: date)
		let daysRange = range(of: .weekday, in: .weekOfYear, for: date)!
		let daysPerWeek = daysRange.upperBound - daysRange.lowerBound
		return daysPerWeek - weekdayComponent.weekday!
	}
	
}
