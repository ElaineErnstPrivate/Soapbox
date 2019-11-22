//
//  FeedViewable.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

protocol FeedViewable:class {
    func showPhotos()
    func showAlert(_ message: String)
    func refresh()
}
