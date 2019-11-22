//
//  LoginViewable.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

protocol LoginViewable: class {
    func navigate()
    func showAnimation()
    func hideAnimation()
    func showAlert(_ message: String)
}
