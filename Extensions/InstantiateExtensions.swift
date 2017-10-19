//
//  InstantiateExtensions.swift
//
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

extension NSObject {
	
	class var nameOfClass: String {
		return "\(self)"
	}
	
}

extension UITableView {
	
	func dequeueReusableCell <T: UITableViewCell> () -> T {
		return self.dequeueReusableCell(withIdentifier: T.nameOfClass) as! T
	}
	
}

extension UICollectionView {
	
	func dequeueReusableCell <T: UICollectionViewCell> (for indexPath: IndexPath) -> T {
		return self.dequeueReusableCell(withReuseIdentifier: T.nameOfClass, for: indexPath) as! T
	}
	
}

extension UIStoryboard {
	
	func instantiateViewController <T: UIViewController> () -> T {
		return self.instantiateViewController(withIdentifier: T.nameOfClass) as! T
	}
	
}

extension UIViewController {
	
	class func instantiateFromStoryboard(name: String) -> Self {
		return UIStoryboard(name: name, bundle: nil).instantiateViewController()
	}
	
}
