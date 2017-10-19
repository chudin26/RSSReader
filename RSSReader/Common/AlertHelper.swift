//
//  AlertHelper.swift
//  RSSReader
//
//  Created by Yuriy Chudin on 29/09/2017.
//  Copyright © 2017 Yuriy Chudin. All rights reserved.
//

import UIKit

class AlertHelper {

	static func inputAlert(title: String, message: String, buttonName: String, placeholder: String, handler: @escaping (String?) -> ()) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: buttonName, style: .default, handler: { _ in handler(alert.textFields![0].text) }))
		alert.addAction(UIAlertAction(title: L10n.Alert.Button.cancel, style: .destructive, handler: { _ in handler(nil) }))
		alert.addTextField(configurationHandler: {(textField: UITextField!) in
			textField.placeholder = placeholder
		})
		
		return alert
	}
	
	static func alert(title: String, message: String, buttons: [String], handler: ((Int) -> ())? = nil) -> UIAlertController {
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		for i in 0 ..< buttons.count {
			alert.addAction(UIAlertAction(title: buttons[i], style: .default, handler: { _ in handler?(i) }))
		}
		
		return alert
	}

}
