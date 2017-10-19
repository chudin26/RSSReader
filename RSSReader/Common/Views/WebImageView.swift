//
//  WebImageView.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 13/10/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit
import AlamofireImage

class WebImageView: UIImageView {
	
	var url: URL! {
		didSet {
			image = nil
			if url == nil {
				return
			}

			let loadingView = LoadingView.showOn(superview: self)
			af_setImage(withURL: url) { response in
				loadingView.hide()
			}
		}
	}

}
