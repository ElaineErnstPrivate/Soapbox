//
//  PhotoRequest.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation

struct PhotoRequest: Codable{
    var method: String
    var api_key: String
    var text: String?
    var format: String
    var nojsoncallback: String
    var per_page: Int
    var page : Int
}

