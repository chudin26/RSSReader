//
//  SourceCell.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class SourceCell: UITableViewCell {
	
	@IBOutlet private var titleLabel: UILabel!
	@IBOutlet private var linkLabel: UILabel!

	func fillBy(source: Source) {
		titleLabel.text = source.title
		linkLabel.text = source.url
	}
	
}
