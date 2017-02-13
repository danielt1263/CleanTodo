//
//  ListViewController.swift
//  CleanTodo
//
//  Created by Daniel Tartaglia on 2/21/16.
//  Copyright © 2016 Daniel Tartaglia. All rights reserved.
//

import UIKit
import PromiseKit


class ListViewController: UIViewController, Promisable {
	
	@IBOutlet weak var noContentView: UIView!
	@IBOutlet weak var tableView: UITableView!
	
	var dataStore: DataStore!
	
	@IBAction func addAction(_ sender: AnyObject) {
		addTodo(self)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		noContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		noContentView.frame = tableView.frame
		view.addSubview(noContentView)
	}
	
	var promise: AnyObject {
		return Promise<Void>(value: ())
	}
}
