//
//  FilterViewController.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 13/10/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

	@IBOutlet private var tableView: UITableView!
	
	private let storage = LocalStorage.shared
	private var sources = [Source]()
	
	private var completionHandler: (([Source]?) -> ())!
	
	static func present(on onVC: UIViewController, sources: [Source], completionHandler: @escaping ([Source]?) -> ()) {
		let vc = StoryboardScene.Main.filterViewController.instantiate()
		vc.sources = sources
		vc.completionHandler = completionHandler
		
		let nc = UINavigationController(rootViewController: vc)
		onVC.present(nc, animated: true, completion: nil)
	}

	@IBAction private func done() {
		completionHandler(storage.sources.filter { self.sources.contains($0) })
		dismiss(animated: true, completion: nil)
	}
	
	@IBAction private func cancel() {
		completionHandler(nil)
		dismiss(animated: true, completion: nil)
	}
	
}

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.sources.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let source = storage.sources[indexPath.row]
		let selected = sources.contains(source)
		if selected {
			tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
		}
		
		let cell: SourceCell = tableView.dequeueReusableCell()
		cell.isSelected = selected
		cell.accessoryType = selected ? .checkmark : .none
		cell.fillBy(source: source)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
		
		let source = storage.sources[indexPath.row]
		if !sources.contains(source) {
			sources.append(source)
		}
	}
	
	func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
		tableView.cellForRow(at: indexPath)?.accessoryType = .none
		
		if let index = sources.index(of: storage.sources[indexPath.row]) {
			sources.remove(at: index)
		}
	}
	
}
