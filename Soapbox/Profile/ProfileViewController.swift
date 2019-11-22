//
//  ProfileViewController.swift
//  Soapbox
//
//  Created by Elaine Ernst on 2019/11/21.
//  Copyright © 2019 Elaine Ernst. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{

    @IBOutlet weak var textField: UITableView!
    @IBOutlet weak var profilePicture: UIImageView!
    let userDefaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.tableFooterView = UIView(frame: CGRect.zero)

        profilePicture.makeRounded()
        if let profileImageData = userDefaults.value(forKey: "Profile"){
            guard let yourImage = UIImage(data:profileImageData as! Data) else{
                return
            }
            self.profilePicture.image = yourImage

        }
        // Do any additional setup after loading the view.
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let email = userDefaults.value(forKey: "Email"), let emailString = email as? String else{
            return cell
        }
        
        cell.textLabel?.text = "Email: \(String(describing: emailString))"
        
        return cell
    }
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
          let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = sourceType
          present(imagePicker, animated:true, completion:nil)
      }
    
    @IBAction func pickAnImage(_ sender:Any) {
          
          presentImagePickerWith(sourceType: UIImagePickerController.SourceType.photoLibrary)

      }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profilePicture.image = image
            let imageData = image.pngData()
            userDefaults.set(imageData, forKey: "Profile")
            dismiss(animated: true, completion: nil)
        }
    }
    
}
