//
//  Entry.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import Foundation

class Entry: RssParseable {
	
	var title: String
	var description: String
	var link: URL
	var pubDate: Date?
	
	var imageUrl: URL?
	
	// RssParseable implementation
	required init?(tag: CXMLTag) {
		guard let title = tag["title"]?.string,
			let description = tag["description"]?.string,
			let link = URL(string: tag["link"]?.string ?? "")
		else {
			return nil
		}
		
		self.title = title
		self.description = description
		self.link = link
		self.pubDate = tag["pubDate"]?.date("EEE, dd MMM yyyy HH:mm:ss z")
		
		imageUrl = URL(string: tag["media:content"]?.attribute("url").string ?? "")
		if imageUrl == nil {
			imageUrl = URL(string: tag["media:group"]?["media:content"]?.attribute("url").string ?? "")
		}
	}
	
}
