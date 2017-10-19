//
//  FeedViewController.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 28/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit
import Alamofire

class FeedViewController: UIViewController {
	
	var sources = [Source]() {
		didSet {
			reloadData()
		}
	}
	
	private var data = [RssParser.Result]()

	@IBOutlet private var tableView: UITableView!
	@IBOutlet private var errorView: UIView!
	@IBOutlet private var emptyView: UIView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NotificationCenter.default.addObserver(forName: LocalStorage.kSourcesChangedNotification, object: nil, queue: nil) { [weak self] notification in
			self?.sources = notification.object as? [Source] ?? []
		}
		
		sources = LocalStorage.shared.sources
	}
	
	private func reloadData() {
		let loadingView = LoadingView.showOn(superview: view)
		
		let group = RequestGroup(urls: sources.flatMap { URL(string: $0.url) })
		group.makeRequests(success: { [weak self] results in
			guard self != nil else { return }
			
			self!.data = []
			for data in results {
				if let result = RssParser().parse(data: data) {
					self!.data.append(result)
					
					print("Entries loaded: \(result.entries.count), url = \(result.source.url)")
				}
			}
			
			loadingView.hide()
			self!.tableView.reloadData()
			
			print("Sources loaded: \(self!.data.count)")
		}) { [weak self] errorString in
			loadingView.hide()
			self?.view.addSubview(self!.errorView, autoLayoutMargin: 0)
		}
	}

	private func entryBy(indexPath: IndexPath) -> Entry {
		return data[indexPath.section].entries[indexPath.row]
	}
	
	@IBAction private func filterClicked() {
		FilterViewController.present(on: self, sources: sources) { [weak self] (sources) in
			if sources != nil {
				self?.sources = sources!
			}
		}
	}
	
	@IBAction private func tryAgainClicked() {
		reloadData()
		
		errorView.removeFromSuperview()
	}
	
}

extension FeedViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		emptyView.isHidden = !data.isEmpty
		
		return data.count
	}
	
	func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return data[section].source.title
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data[section].entries.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: EntryCell = tableView.dequeueReusableCell()
		cell.fillBy(entry: entryBy(indexPath: indexPath))
		
		return cell
	}

}

extension FeedViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		
		let entry = entryBy(indexPath: indexPath)
		let vc = DetailsViewController.create(withEntry: entry)
		navigationController?.pushViewController(vc, animated: true)
	}
	
}
