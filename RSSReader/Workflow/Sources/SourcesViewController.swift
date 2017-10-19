//
//  SourcesViewController.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class SourcesViewController: UIViewController {
	
	@IBOutlet private var tableView: UITableView!
	
	let storage = LocalStorage.shared
	
	@IBAction private func addSourceAction() {
		let title = L10n.Alert.Source.title
		let message = L10n.Alert.Source.message
		let buttonName = L10n.Alert.Button.add
		let alert = AlertHelper.inputAlert(title: title, message: message, buttonName: buttonName, placeholder: "https://") { [unowned self] url in
			if url?.isEmpty != false {
				return
			}
			
			let loadingView = LoadingView.showOn(superview: self.view.window!)
			RssParser().parseAsync(url: url!, completionHandler: { result in
				loadingView.hide()
				
				if result != nil {
					self.addSource(result!.source)
				} else {
					let alert = AlertHelper.alert(title: L10n.Error.title, message: L10n.Error.wrongUrl, buttons: [L10n.Alert.Button.ok])
					self.present(alert, animated: true, completion: nil)
				}
			})
		}
		
		self.present(alert, animated: true, completion: nil)
	}
	
	private func addSource(_ source: Source) {
		tableView.beginUpdates()
		
		let indexPath = IndexPath(row: storage.sources.count, section: 0)
		tableView.insertRows(at: [indexPath], with: .automatic)
		storage.add(source: source)
		
		tableView.endUpdates()
	}
	
	private func removeSource(_ source: Source, atIndexPath indexPath: IndexPath) {
		tableView.beginUpdates()
		
		tableView.deleteRows(at: [indexPath], with: .automatic)
		storage.remove(source: source)
		
		tableView.endUpdates()
	}

}

extension SourcesViewController: UITableViewDataSource {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return storage.sources.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let source = storage.sources[indexPath.row]
		
		let cell: SourceCell = tableView.dequeueReusableCell()
		cell.fillBy(source: source)
		return cell
	}
	
}

extension SourcesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
		let action = UITableViewRowAction(style: .destructive, title: L10n.Action.remove) { [unowned self] (_, indexPath) in
			let source = self.storage.sources[indexPath.row]
			self.removeSource(source, atIndexPath: indexPath)
		}
		
		return [action]
	}
	
}
