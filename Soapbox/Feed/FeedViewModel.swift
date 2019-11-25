//
//  FeedViewModel.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import Foundation
import CoreData

class FeedViewModel:NSObject,NSFetchedResultsControllerDelegate{
    let downloader = URLSessionProvider()
    let manager = URLSessionProvider()
    var photos: [AllPhotos] = []
    var flickerPhotos : FlickrPhoto?
    var containsPhotos : Bool = false
    private weak var view: FeedViewable?

    public init(viewable:FeedViewable){
        self.view = viewable
    }
    
      func getRecentPhotos(handler: @escaping(_ success: Bool?,_ error: NetworkError?) -> Void){
               let page = Int.random(in: 0..<12)
               let request = PhotoRequest(method: "flickr.photos.getRecent", api_key: NetworkManager.shared.uniqueKey, format: "json", nojsoncallback: "1",per_page: 25, page: page)
               manager.request(type: FlickrPhoto.self, service: PhotosAPI.getPhotos(request: request)) { response in
                  switch response {
                  case .success(let currentPhotos):
                    self.flickerPhotos = currentPhotos
                     DispatchQueue.main.async {
                          handler(true, nil)
                      }
                  case .failure(let error):
                      DispatchQueue.main.async {
                          handler(nil ,error)
                      }
                   
                }       
        }
    }
    
    // Dowload images from flickr url
    func downloadImages(photoUrl: URL, handler: @escaping(_ success: Data? ,_ error: Error?) -> Void){
        self.downloader.requestDownloadData(url: photoUrl) { (data, error) in
         if let error = error {
             handler(nil, error)
         }else{
             guard let photoData = data else{
                 return
             }
             handler(photoData, nil)

            }
        }
    }
}
