//
//  CreateAccountViewModel.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/18.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import Firebase

class CreateAccountViewModel{
    private weak var view: CreateAccountViewable?

    public init(viewable:CreateAccountViewable){
        self.view = viewable
    }
    
    // Create an account on Firebase
    func createAccount(with email: String, password: String){
        self.view?.showAnimation()
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        self.view?.hideAnimation()
            if let err = error{
                self.view?.showAlert(err.localizedDescription)
            }else{
                self.view?.navigate()
            }
            
        }
    }
}
