//
//  LoginViewModel.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import Firebase

class LoginViewModel {
    
    private weak var view: LoginViewable?
    var email: String?
    var password: String?
    let userDefaults = UserDefaults.standard

    public init(viewable:LoginViewable){
        self.view = viewable
    }
    
    func login(with email: String, password: String){
        self.view?.showAnimation()
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            self.view?.hideAnimation()
            if let err = error{
                self.view?.showAlert(err.localizedDescription)
            }
            else{
                self.userDefaults.set(false, forKey: "isLoggedOut")
                self.view?.navigate()
            }
        }
    }
    
    func checkAuthStatus(){
        self.view?.showAnimation()
        Auth.auth().addStateDidChangeListener({ (auth:Auth, user:User?) in
            self.view?.hideAnimation()
            if user != nil {
                self.userDefaults.set(user?.email, forKey: "Email")
                self.view?.navigate()
            }else{
                print("You need to sign up or login first")
            }
        })
    }
}
