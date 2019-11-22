//
//  FeedTabBarControllerViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/21.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class FeedTabBarControllerViewController: UITabBarController {
    var dataModel: DataController!

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let firstTab = self.viewControllers?[0] as? FeedViewController,
        let secondTab = self.viewControllers?[1] as? FavouritesViewController else {
            return
        }
        firstTab.dataModel = dataModel
        secondTab.dataModel = dataModel
        // Do any additional setup after loading the view.
    }
}
