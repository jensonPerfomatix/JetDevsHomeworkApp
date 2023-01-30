//
//  UIViewController.swift
//  JetDevsHomeWork
//
//  Created by Jenson John on 30/01/23.
//

import UIKit

extension UIViewController {
    
    func showAlert(alertText: String, alertMessage: String) {
        let alert = UIAlertController(title: alertText, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
