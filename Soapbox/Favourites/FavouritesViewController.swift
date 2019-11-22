//
//  FavouritesViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/19.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import CoreData
class FavouritesViewController: UIViewController, FavouritesViewable {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var fetchResultsController : NSFetchedResultsController<Favourites>!

    var viewModel : FavouritesViewModel?
    var dataModel: DataController!

       
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = FavouritesViewModel(viewable: self)
        initializeCollectionView()
        getAllPhotos()
        self.refresh()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           getAllPhotos()
           self.refresh()
        
    }
    
    func refresh() {
        DispatchQueue.main.async {
            if let indexPath = self.collectionView.indexPathsForSelectedItems {
                self.collectionView.reloadItems(at: indexPath)
            }
        }
    }
    
    func initializeCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
       
          let space:CGFloat = 2.0
          let dimension = (view.frame.size.width - (2 * space)) / 2.0

          flowLayout.minimumInteritemSpacing = space
          flowLayout.minimumLineSpacing = space
          flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }

}

extension FavouritesViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell
        
        let photo = fetchResultsController.object(at: indexPath)
        if photo.imageData == nil{
    
            guard let urlString = photo.imageUrl,
                let url = URL(string: urlString) else{
                return UICollectionViewCell()
                
            }
            cell?.activityIndicator.startAnimating()
            self.viewModel?.downloadImages(photoUrl: url) { (photoData, error) in
                guard let data = photoData as NSData? else{
                    print("Fails to assign data")
                    return
                }
               
                photo.imageData = data as Data
               // save data to photo object
                try? self.dataModel.viewContext.save()
               
                guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData), let title = photo.photoTitle else{ return }
               DispatchQueue.main.async {
                   cell?.activityIndicator.stopAnimating()
                   cell?.configureCell(image: image, title: title)
            
                }
           }
       } else{
            guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData),
             let title = photo.photoTitle else{
                   print("image failed")
                   return UICollectionViewCell()
               }
            cell?.configureCell(image: image, title: title)
           }
           return cell ?? UICollectionViewCell()
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToDelete = fetchResultsController.object(at: indexPath)
        self.removeFromFavourites(photo: photoToDelete)
    }
}


extension FavouritesViewController: NSFetchedResultsControllerDelegate{
     // Remove from favourites
     func removeFromFavourites(photo: Favourites){
             dataModel.viewContext.delete(photo)
            try? dataModel.viewContext.save()
     }
     
      // Load photos
     func getAllPhotos() {

         // set up fetched results controller
         let fetchRequest : NSFetchRequest<Favourites> = Favourites.fetchRequest()
         let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
         fetchRequest.sortDescriptors = [sortDescriptor]
               
         fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
         fetchResultsController.delegate = self
         
         do {
             try fetchResultsController.performFetch()
         } catch  let error {
             print("Error:",error.localizedDescription)
         }
     }
    // Update objects
       func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
           switch type {
           case .delete:
               collectionView.deleteItems(at: [indexPath!])
           
           default:
               break
           }
       }

}
