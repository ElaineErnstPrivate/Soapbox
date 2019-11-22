//
//  CreateAccountViewable.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/18.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

protocol CreateAccountViewable: class {
    func navigate()
    func showAnimation()
    func hideAnimation()
    func showAlert(_ message: String)
}
