//
//  FeedViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/17.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreData
class FeedViewController: UIViewController, FeedViewable{
   
    @IBOutlet weak var noPhotosLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    var fetchResultsController : NSFetchedResultsController<AllPhotos>!
    var dataModel: DataController!

    var viewModel : FeedViewModel?
        override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
           
        viewModel = FeedViewModel(viewable: self)
        getAllPhotos()
        initializeCollectionView()
        setupPhotoCollection()
        noPhotosLabel.isHidden = true

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
    
    func setupPhotoCollection(){
        if viewModel!.containsPhotos{
            self.refresh()
        }else {
            viewModel?.getRecentPhotos(handler: { (sucess, error) in
                if let error = error {
                    self.displayAlert(message: error.description)
                }else{
                guard let photos = self.viewModel?.flickerPhotos, let count = photos.photos?.photo.count  else{
                    return
                }
                if count > 0{
                    self.noPhotosLabel.isHidden = true
                    self.savePhotos(photos)
                }else{
                    self.noPhotosLabel.isHidden = false
                }
                self.collectionView.reloadData()
            }
                
            })
            
        }
    }
    
    func showPhotos(){
        guard let photos = viewModel?.flickerPhotos else{
            self.noPhotosLabel.isHidden = false
            return
        }
            self.noPhotosLabel.isHidden = true
            self.savePhotos(photos)
    }
    
    func showAlert(_ message: String) {
        self.displayAlert(message: message)
    }
    
    func refresh() {
        DispatchQueue.main.async {
            if let indexPath = self.collectionView.indexPathsForSelectedItems {
                self.collectionView.reloadItems(at: indexPath)
            }
        }
    }
    
    @IBAction func reloadNewContent(_ sender: Any) {
        self.deletePhotos()
        self.viewModel?.containsPhotos = false
        viewModel?.getRecentPhotos(handler: { (sucess, error) in
            if let error = error {
                self.displayAlert(message: error.description)
            }else{
                guard let photos = self.viewModel?.flickerPhotos, let count = photos.photos?.photo.count  else{
                    return
                }
                if count > 0{
                    self.noPhotosLabel.isHidden = true
                    self.savePhotos(photos)
                }else{
                    self.noPhotosLabel.isHidden = false
                }
                self.collectionView.reloadData()
            }
            
        })
    }

}

extension FeedViewController: UICollectionViewDelegate, UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedCollectionViewCell", for: indexPath) as? FeedCollectionViewCell
        
        let photo = fetchResultsController.object(at: indexPath)
           if photo.imageData == nil{
               guard let urlString = photo.imageUrl, let url = URL(string: urlString) else{
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
                   
                   guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData), let title = photo.photoTitle else{
                       print("image failed")
                       return
                   }
                   DispatchQueue.main.async {
                       cell?.activityIndicator.stopAnimating()
                    cell?.configureCell(image: image, title: title )
                   }
               }
           }
           else{
               guard let imageData = photo.imageData as Data?,  let image = UIImage(data: imageData), let title = photo.photoTitle else{
                   print("image failed")
                   return UICollectionViewCell()
               }
            cell?.configureCell(image: image, title:title)
           }
           return cell ?? UICollectionViewCell()
       }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoToSave = fetchResultsController.object(at: indexPath)
        self.saveToFavourites(photo: photoToSave)
    }
  
}

extension FeedViewController: NSFetchedResultsControllerDelegate{
    // Delete all photos in database
          func deletePhotos(){
            viewModel?.containsPhotos = false
              let photos = fetchResultsController.fetchedObjects
              if let photos = photos {
                  for photo in photos {
                       dataModel.viewContext.delete(photo)
                      try? dataModel.viewContext.save()
                  }
              }
          }
       
       // Save favourites
       func saveToFavourites(photo: AllPhotos){
           let currentPhoto = Favourites(context:dataModel.viewContext)
           currentPhoto.dateCreated = Date()
           currentPhoto.imageUrl = photo.imageUrl
           currentPhoto.imageData = photo.imageData
            currentPhoto.photoTitle = photo.photoTitle
           try? dataModel.viewContext.save()
           self.showAlert("Photo added to favourites")
          }
       
       // Save all photos
       func savePhotos(_ photos : FlickrPhoto){
           guard let photoArray = photos.photos?.photo else {
               return
           }
           
           for photo in photoArray{
               let currentPhoto = AllPhotos(context: dataModel.viewContext)
               currentPhoto.dateCreated = Date()
               currentPhoto.imageUrl = photo.photoURL().absoluteString
                currentPhoto.photoTitle = photo.title
               try? dataModel.viewContext.save()
              
           }
       }
       
       // Load photos
       func getAllPhotos() {
           // set up fetched results controller

           let fetchRequest : NSFetchRequest<AllPhotos> = AllPhotos.fetchRequest()
           let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
           fetchRequest.sortDescriptors = [sortDescriptor]
                 
           fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataModel.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
           fetchResultsController.delegate = self
           
           do {
               try fetchResultsController.performFetch()
           } catch  let error {
               print("Error:",error.localizedDescription)
           }
           do {
               let photoCount = try fetchResultsController.managedObjectContext.count(for: fetchRequest)
               
               if photoCount > 0 {
                viewModel?.containsPhotos = true
               } else {
                viewModel?.containsPhotos = false
               }
               
           } catch let error {
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
