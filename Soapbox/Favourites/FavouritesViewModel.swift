//
//  FavouritesViewModel.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import CoreData

class FavouritesViewModel: NSObject, NSFetchedResultsControllerDelegate{
    private weak var view: FavouritesViewable?
    let downloader = URLSessionProvider()
    

    public init(viewable:FavouritesViewable){
        self.view = viewable
    }
    
    // Dowload images from flickr url
       func downloadImages(photoUrl: URL, handler: @escaping(_ success: Data? ,_ error: Error?) -> Void){
           self.downloader.requestDownloadData(url: photoUrl) { (data, error) in
            if let error = error {
                handler(nil, error)
            }
            else{
                guard let photoData = data else{
                    return
                }
                handler(photoData, nil)
            }
        }
    }
    

    
}
