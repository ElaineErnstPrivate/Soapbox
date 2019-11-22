//
//  FeedCollectionViewCell.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/18.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class FeedCollectionViewCell: UICollectionViewCell {
    var isFavourite: Bool = false
    
    @IBOutlet weak var photoTitle: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    func configureCell(image: UIImage, title: String){
        self.image.image = image
        self.photoTitle.text = title

    }
}
