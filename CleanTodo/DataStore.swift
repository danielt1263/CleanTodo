//
//  DataStore.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import Foundation
import CoreData
import PromiseKit


class DataStore {
	
	func addTodo(todo: Todo) -> Promise<Void> {
		return Promise { fulfill, reject in
			let todoDescription = NSEntityDescription.entityForName("TodoItem", inManagedObjectContext: managedObjectContext)!
			let todoItem = NSManagedObject(entity: todoDescription, insertIntoManagedObjectContext: managedObjectContext) as! TodoItem
			todoItem.name = todo.name
			todoItem.date = todo.date
			do {
				try saveContext()
				fulfill()
			}
			catch {
				reject(error)
			}
		}
	}
	
	//func todoItemsBetweenStartDate(startDate: NSDate, endDate: NSDate) -> Observable<[Todo]> {
	//	return Observable.create { observer in
	//		let calendar = NSCalendar.autoupdatingCurrentCalendar()
	//		let predicate = NSPredicate(format: "(date >= %@) AND (date <= %@)", calendar.dateForBeginningOfDay(startDate), calendar.dateForEndOfDay(endDate))
	//		let fetchRequest = NSFetchRequest(entityName: "TodoItem")
	//		fetchRequest.predicate = predicate
	//		managedObjectContext.performBlock {
	//			do {
	//				let results = try managedObjectContext.executeFetchRequest(fetchRequest) as! [TodoItem]
	//				let todos = results.map { Todo(todoItem: $0) }
	//				observer.onNext(todos)
	//				observer.onCompleted()
	//			}
	//			catch {
	//				observer.onError(error)
	//			}
	//		}
	//		return NopDisposable.instance
	//	}
	//}
}

extension Todo {
	init(todoItem: TodoItem) {
		name = todoItem.name!
		date = todoItem.date!
	}
}


private var applicationDocumentsDirectory: NSURL = {
	let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
	return urls[urls.count-1]
}()

private var managedObjectModel: NSManagedObjectModel = {
	let modelURL = NSBundle.mainBundle().URLForResource("CleanTodo", withExtension: "momd")!
	return NSManagedObjectModel(contentsOfURL: modelURL)!
}()

private var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
	let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
	let url = applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
	var failureReason = "There was an error creating or loading the application's saved data."
	do {
		try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
	} catch {
		var dict = [String: AnyObject]()
		dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
		dict[NSLocalizedFailureReasonErrorKey] = failureReason
		
		dict[NSUnderlyingErrorKey] = error as NSError
		let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
		NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
		abort()
	}
	
	return coordinator
}()

private var managedObjectContext: NSManagedObjectContext = {
	let coordinator = persistentStoreCoordinator
	var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
	managedObjectContext.persistentStoreCoordinator = coordinator
	return managedObjectContext
}()

// MARK: - Core Data Saving support

private func saveContext() throws {
	if managedObjectContext.hasChanges {
		try managedObjectContext.save()
	}
}
