//
//  CreateAccountViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/18.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, CreateAccountViewable {
  
    
    var viewModel : CreateAccountViewModel?
    var dataModel: DataController!

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = CreateAccountViewModel(viewable: self)
        self.navigationItem.title = "Create a new ccount"
        // Do any additional setup after loading the view.
    }
    
     func navigate() {
        guard let window = UIApplication.shared.keyWindow,
        let controller = storyboard?.instantiateViewController(identifier: "FeedViewController") as? FeedTabBarControllerViewController else {
                return
        }
        controller.dataModel = dataModel
        window.rootViewController = controller
      }
      
      func showAnimation() {
        self.activityIndicator.startAnimating()
      }
      
      func hideAnimation() {
        self.activityIndicator.stopAnimating()
      }
      
      func showAlert(_ message: String) {
        self.displayAlert(message: message)
      }
    
    @IBAction func createAccount(_ sender: Any) {
        guard let email = emailTextfield.text , let password = passwordTextfield.text else{
            self.displayAlert(message: "Please enter all fields")
            return
        }

        self.viewModel?.createAccount(with: email, password: password)
    }
}
