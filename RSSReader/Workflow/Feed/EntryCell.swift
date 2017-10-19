//
//  EntryCell.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
	
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var descriptionLabel: UILabel!
	@IBOutlet var entryImageView: WebImageView!
	
	@IBOutlet var imageConstraint: NSLayoutConstraint!
	@IBOutlet var noimageConstraint: NSLayoutConstraint!
	
	func fillBy(entry: Entry) {
		titleLabel.text = entry.title
		descriptionLabel.text = entry.description
		
		let hasImage = entry.imageUrl != nil
		imageConstraint.isActive = hasImage
		noimageConstraint.isActive = !hasImage

		entryImageView.url = entry.imageUrl
	}

}
