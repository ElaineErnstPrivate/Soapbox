//
//  Photos.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/10/01.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
// MARK: - FlickrPhoto
struct FlickrPhoto: Codable {
    let stat: String?
    let photos: Photos?
}

// MARK: - Photos
struct Photos: Codable {
    let perpage, pages: Int
    let photo: [Photo]
    let total: Int
    let page: Int
}
// MARK: - Photo
struct Photo: Codable {
    let owner, secret, server, id: String
    let farm: Int
    let title: String
    let isfriend, isfamily, ispublic: Int
    
    func photoURL() -> URL {

        return URL(string: "https://farm\(String(describing: farm)).staticflickr.com/\(String( server))/\(String(describing: id))_\(secret).jpg")!
    }
    
}
