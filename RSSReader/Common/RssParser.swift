//
//  RssParser.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

protocol RssParseable {
	init?(tag: CXMLTag)
}

class RssParser {
	
	struct Result {
		var source: Source
		var entries: [Entry]
	}
	
	func parse(data: Data) -> Result? {
		guard
			let parser = CXMLParser(data: data),
			let channel = parser["channel"],
			let source = Source(tag: channel)
		else {
			return nil
		}
		
		var entries = [Entry]()
		for item in channel.elementsNamed("item") {
			if let entry = Entry(tag: item) {
				entries.append(entry)
			} else {
				print(L10n.Error.Parser.wrongItemFormat + " (title = \(item["title"]?.string ?? "nil")")
			}
		}
		
		return Result(source: source, entries: entries)
	}
	
	func parseAsync(url urlString: String, completionHandler: @escaping (Result?) -> ()) {
		guard let url = URL(string: urlString) else {
			completionHandler(nil)
			return
		}
		
		DispatchQueue.global().async {
			let data = try? Data(contentsOf: url)
			let result = data != nil ? self.parse(data: data!) : nil
			result?.source.url = urlString
			
			DispatchQueue.main.async {
				completionHandler(result)
			}
		}
		
	}

}
