//
//  UIViewControllerExtention.swift
//  FutureBank
//
//  Created by Elaine Ernst on 2019/08/28.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    typealias AlertHandler = () -> Void
    
   
    func displayAlert(title: String = "",
                      buttonText: String = "OK",
                      message: String,
                      onCompletion: AlertHandler? = nil) {
    
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: { (_) in
            onCompletion?()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
