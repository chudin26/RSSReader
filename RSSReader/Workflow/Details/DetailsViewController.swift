//
//  DetailsViewController.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
	
	@IBOutlet private var webView: UIWebView!
	
	var entry: Entry!
	
	static func create(withEntry entry: Entry) -> DetailsViewController {
		let vc: DetailsViewController = StoryboardScene.Main.detailsViewController.instantiate()
		vc.entry = entry
	
		return vc
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		title = entry.title

		let request = URLRequest(url: entry.link)
		webView.loadRequest(request)
    }

}
