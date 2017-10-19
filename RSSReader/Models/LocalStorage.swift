//
//  LocalStorage.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import Foundation

class LocalStorage {
	
	static let kSourcesChangedNotification = Notification.Name(rawValue: "LocalStorage.Notification.SourcesChanged")
	
	static let shared = LocalStorage()
	
	private let kSourcesKey = "sources"
	private let userDefaults = UserDefaults.standard
    
    private init() {}
	
	var sources: [Source] {
		if let unarchivedObject = userDefaults.object(forKey: kSourcesKey) as? Data {
			let array = NSKeyedUnarchiver.unarchiveObject(with: unarchivedObject) as? [Source]
			return array ?? [initialSource]
		}
		
		return [initialSource]
	}
	
	func add(source: Source) {
		if !sources.contains(where: { $0.url == source.url }) {
			updateSources(sources + [source])
		}
	}
	
	func remove(source: Source) {
		updateSources(sources.filter { $0.url != source.url } )
	}

	private func updateSources(_ newSources: [Source]) {
		let data = NSKeyedArchiver.archivedData(withRootObject: newSources)
		userDefaults.set(data, forKey: kSourcesKey)
		userDefaults.synchronize()
		
		NotificationCenter.default.post(name: LocalStorage.kSourcesChangedNotification, object: sources)
	}
	
	private lazy var initialSource: Source = {
		let source = Source(title: "Apple Hot News", url: "http://images.apple.com/main/rss/hotnews/hotnews.rss")
		source.desc = "Hot News provided by Apple."
		return source
	}()
	
}
