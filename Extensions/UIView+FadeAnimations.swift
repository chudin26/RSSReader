//
//  UIView+FadeAnimations.swift
//
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

extension UIView {
	
	typealias AnimationBlock = (UIView) -> ()
	
	enum FadeType {
		case fade
		case scale
		
		var hideBlock: AnimationBlock {
			switch self {
			case .fade:
				return { $0.alpha = 0 }
			case .scale:
				return { $0.transform = CGAffineTransform(scaleX: 0.01, y: 0.01) }
			}
		}

		var showBlock: AnimationBlock {
			switch self {
			case .fade:
				return { $0.alpha = 1 }
			case .scale:
				return { $0.transform = CGAffineTransform(scaleX: 1, y: 1) }
			}
		}
	}

	func fadeIn(duration: TimeInterval = 0.25, delay: TimeInterval = 0, type: FadeType = .fade, completion: ((Bool) -> ())? = nil) {
		isHidden = false
		type.hideBlock(self)
		
		UIView.animate(withDuration: duration, delay: delay, animations: {
			type.showBlock(self)
		}, completion: { success in
			completion?(success)
		})
	}
	
	func fadeOut(duration: TimeInterval = 0.25, delay: TimeInterval = 0, type: FadeType = .fade, completion: ((Bool) -> ())? = nil) {
		UIView.animate(withDuration: duration, delay: delay, options: .beginFromCurrentState, animations: {
			type.hideBlock(self)
		}, completion: { success in
			self.isHidden = true
			completion?(success)
		})
	}
	
	func fade(_ out: Bool, duration: TimeInterval = 0.25, delay: TimeInterval = 0, type: FadeType = .fade, completion: ((Bool) -> ())? = nil) {
		if out {
			fadeOut(duration: duration, delay: delay, type: type, completion: completion)
		} else {
			fadeIn(duration: duration, delay: delay, type: type, completion: completion)
		}
	}

}
