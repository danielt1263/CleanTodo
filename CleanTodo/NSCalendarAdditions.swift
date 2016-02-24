//
//  NSCalendarAdditions.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation


extension NSCalendar {
	
	func dateForEndOfDay(date: NSDate) -> NSDate {
		let dayComponent = NSDateComponents()
		dayComponent.day = 1
		let nextDay = dateByAddingComponents(dayComponent, toDate: dateForBeginningOfDay(date), options: NSCalendarOptions(rawValue: 0))!
		return nextDay.dateByAddingTimeInterval(-1)
	}
	
	func dateForEndOfFollowingWeekWithDate(date: NSDate) -> NSDate {
		let endOfWeek = dateForEndOfWeekWithDate(date)
		let nextWeekComponent = NSDateComponents()
		nextWeekComponent.weekOfYear = 1
		return dateByAddingComponents(nextWeekComponent, toDate: endOfWeek, options: NSCalendarOptions(rawValue: 0))!
	}

	func dateForBeginningOfDay(date: NSDate) -> NSDate {
		let components = self.components([.Year, .Month, .Day], fromDate: date)
		return dateFromComponents(components)!
	}
	
	func dateForEndOfWeekWithDate(date: NSDate) -> NSDate {
		let daysRemainingThisWeek = daysRemainingInWeekWithDate(date)
		let remainingDaysComponent = NSDateComponents()
		remainingDaysComponent.day = daysRemainingThisWeek
		return dateByAddingComponents(remainingDaysComponent, toDate: date, options: NSCalendarOptions(rawValue: 0))!
	}
	
	func daysRemainingInWeekWithDate(date: NSDate) -> Int {
		let weekdayComponent = components([.Weekday], fromDate: date)
		let daysRange = rangeOfUnit(.Weekday, inUnit: .WeekOfYear, forDate: date)
		let daysPerWeek = daysRange.length
		return daysPerWeek - weekdayComponent.weekday
	}
	
}