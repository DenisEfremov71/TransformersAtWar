//
//  UiHelper.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-27.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation
import UIKit

class UiHelper {
        
    static func showAlert(for viewController: UIViewController, with alert: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlert(for viewController: UIViewController, with alert: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: nil, message: alert, preferredStyle: UIAlertController.Style.alert)
            let  okButton = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
                completion()
            })
            alertController.addAction(okButton)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func showAlert(for viewController: UIViewController, with alert: String, title: String, buttonCaption: String = "OK") {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: alert, preferredStyle: UIAlertController.Style.alert)
            let alertAction = UIAlertAction(title: buttonCaption, style: .default, handler: nil)
            alertController.addAction(alertAction)
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    static func addActivityIndicator(view: UIView, activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.center = view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
        }
    }
    
    static func removeActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    static func getStatusBarHeight() -> CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
