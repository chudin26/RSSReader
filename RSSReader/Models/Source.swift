//
//  Source.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import Foundation

class Source: NSObject, RssParseable, NSCoding {

	var title: String
	var url: String!
	var desc: String?
	
	init(title: String, url: String, description: String? = nil) {
		self.title = title
		self.url = url
		self.desc = description
	}

	// RssParseable implementation
	required init?(tag: CXMLTag) {
		guard let title = tag["title"]?.string else {
			return nil
		}
		
		self.title = title
		self.desc = tag["description"]?.string
	}
	
	// NSCoding implementation
	required init(coder aDecoder: NSCoder) {
		self.title = aDecoder.decodeObject(forKey: "title") as! String
		self.url = aDecoder.decodeObject(forKey: "url") as! String
		self.desc = aDecoder.decodeObject(forKey: "desc") as? String
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(self.title, forKey: "title")
		aCoder.encode(self.url, forKey: "url")
		aCoder.encode(self.desc, forKey: "desc")
	}
	
	override func isEqual(_ object: Any?) -> Bool {
		if let rhsUrl = (object as? Source)?.url {
			return url == rhsUrl
		} else {
			return false
		}
	}
	
}
