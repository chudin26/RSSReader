//
//  UIView+Layout.swift
//
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

extension UIView {
	
	@discardableResult
	func addConstraint(toView: UIView, attribute: NSLayoutAttribute, constant: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
		let constraint: NSLayoutConstraint
		if attribute == .width || attribute == .height {
			constraint = NSLayoutConstraint(item: toView, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: attribute, multiplier: multiplier, constant: constant)
		} else {
			var constant = constant
			if [.trailing, .bottom, .right].contains(attribute) {
				constant = -constant
			}
			
			constraint = NSLayoutConstraint(item: toView, attribute: attribute, relatedBy: .equal, toItem: self, attribute: attribute, multiplier: multiplier, constant: constant)
		}
		
		constraint.isActive = true
		addConstraint(constraint)
		
		return constraint
	}
	
	@discardableResult
	func addConstraint(attribute: NSLayoutAttribute, constant: CGFloat, multiplier: CGFloat = 1) -> NSLayoutConstraint {
		precondition(attribute == .width || attribute == .height, "Attribute must be NSLayoutAttributeWidth or NSLayoutAttributeHeight")
		
		let constraint = NSLayoutConstraint(item: self, attribute: attribute, relatedBy: .equal, toItem: nil, attribute: attribute, multiplier: multiplier, constant: constant)
		addConstraint(constraint)
		
		return constraint
	}
	
	func addConstraints(toView view: UIView, attributes: [NSLayoutAttribute: CGFloat]) {
		for attr in attributes {
			if attr.key == .width || attr.key == .height {
				view.addConstraint(attribute: attr.key, constant: attr.value)
			} else {
				addConstraint(toView: view, attribute: attr.key, constant: attr.value)
			}
		}
	}
	
	@discardableResult
	func addSpacingConstraints(betweenViews views: [UIView], axis: UILayoutConstraintAxis, spacing: CGFloat = 0) -> [NSLayoutConstraint] {
		let firstAttribute = axis == .horizontal ? NSLayoutAttribute.trailing : NSLayoutAttribute.bottom
		let secondAttribute = axis == .horizontal ? NSLayoutAttribute.leading : NSLayoutAttribute.top
		
		var constraints = [NSLayoutConstraint]()
		for i in 0 ..< views.count - 1 {
			let constraint = NSLayoutConstraint(item: views[i + 1], attribute: secondAttribute, relatedBy: .equal, toItem: views[i], attribute: firstAttribute, multiplier: 1, constant: spacing)
			constraints.append(constraint)
		}
		
		addConstraints(constraints)
		return constraints
	}
	
	func addSubview(_ view: UIView, autoLayoutMargin margin: CGFloat) {
		addSubview(view, autoLayoutEdgeMargin: UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin))
	}
	
	func addSubview(_ view: UIView, autoLayoutEdgeMargin margin: UIEdgeInsets) {
		addSubview(view, attributes: [.leading: margin.left,
		                              .trailing: margin.right,
		                              .top: margin.top,
		                              .bottom: margin.bottom])
	}
	
	func addSubview(_ view: UIView, attributes: [NSLayoutAttribute]) {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(view)
		for attr in attributes {
			addConstraint(toView: view, attribute: attr, constant: 0)
		}
	}

	func addSubview(_ view: UIView, attributes: [NSLayoutAttribute: CGFloat]) {
		view.translatesAutoresizingMaskIntoConstraints = false
		
		addSubview(view)
		addConstraints(toView: view, attributes: attributes)
	}
	
}
