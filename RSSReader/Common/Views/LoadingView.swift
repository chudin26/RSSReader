//
//  LoadingView.swift
//
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class LoadingView: UIView {
	
	@discardableResult
	class func showOn(superview: UIView, delay: TimeInterval = 0) -> LoadingView {
		let loadingView = LoadingView()
		superview.addSubview(loadingView, autoLayoutMargin: 0)

		loadingView.backgroundColor = UIColor(white: 0, alpha: 0.5)
		if let control = superview as? UIControl {
			control.isEnabled = false
		}
		
		let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .white)
		loadingView.addSubview(indicatorView, attributes: [.centerX, .centerY])
		indicatorView.startAnimating()
		
		loadingView.fadeIn(duration: 0.2, delay: delay)
		return loadingView
	}
	
	func hide() {
		self.fadeOut(duration: 0.1) { _ in
			if let control = self.superview as? UIControl {
				control.isEnabled = true
			}
			
			self.removeFromSuperview()
		}
	}
	
}
