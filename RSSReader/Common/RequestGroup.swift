//
//  RequestGroup.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 18/10/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit
import Alamofire

class RequestGroup {
	
	var urls = [URL]()
	
	init(urls: [URL]) {
		self.urls = urls
	}
	
	func makeRequests(success: @escaping ([Data]) -> (), error: ((String) -> ())?) {
		if urls.isEmpty {
			success([])
			return
		}
		
		var results = [Data?](repeating: nil, count: urls.count)
		
		var counter = urls.count
		for (index, url) in urls.enumerated() {
			Alamofire.request(url).response(completionHandler: { response in
				results[index] = response.error == nil ? response.data : nil
				
				counter -= 1
				if counter == 0 {
					if results.contains(where: { $0 == nil } ) {
						error?("Fetching error")
					} else {
						success(results.flatMap { $0 })
					}
				}
			})
		}
	}

}
