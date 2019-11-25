//
//  ViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import Foundation
import Firebase
class LoginViewController: UIViewController , LoginViewable, UITextFieldDelegate{
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextFiels: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var viewModel : LoginViewModel?
    let dataModel = DataController(modelName: "Soapbox")


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        dataModel.load()
        viewModel = LoginViewModel(viewable: self)
        let userdefaults = UserDefaults.standard
        if !userdefaults.bool(forKey: "isLoggedOut"){
          viewModel?.checkAuthStatus()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func createNewAccount(_ sender: Any) {
        let controller = CreateAccountViewController(nibName: "CreateAccountViewController", bundle:    nil)
        controller.dataModel = dataModel
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        guard let email = emailTextField.text , let password = passwordTextFiels.text else{
            self.displayAlert(message: "Please enter all fields")
            return
        }
        self.viewModel?.login(with: email, password: password)
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
}

