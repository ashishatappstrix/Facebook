 //
//  HomeVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/18/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

protocol HomeVCDelegate {
    func updateUserInfo()
}
class HomeVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    let homeAPIInteractor = HomeAPIInteractor()
    // ui obj
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var editBioButton: UIButton!
    
    // code obj (to build logic of distinguishing tapped / shown Cover / user)
    var isCoverImageTapped = false
    var isUserImageTapped = false
    var imageViewTapped : ImageType = .Cover
    
    
    
    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()
        // run funcs
        configure_userImageView()
        loadUser()
        Helper().downloadImage(path: CustomerProfile.shared.userCoverImageURL, showIn: coverImageView, orShow: "HomeCover.png")
        Helper().downloadImage(path: CustomerProfile.shared.userDisplayImageURL, showIn: userImageView, orShow: "user.png")
    }
    
    func loadUser() {
        
        userName.text = Helper().getUserFullname()

        if !CustomerProfile.shared.userBio.isEmpty {
            userBioLabel.text = CustomerProfile.shared.userBio
        } else {
            self.editBioButton.setTitle("Add Temporary Bio", for: .normal)
        }
    }
    
    // configuring the appearance of userImageView
    func configure_userImageView() {
        
        // creating layer that will be applied to userImageView (layer - broders of user)
        let border = CALayer()
        border.borderColor = UIColor.white.cgColor
        border.borderWidth = 5
        border.frame = CGRect(x: 0, y: 0, width: userImageView.frame.width, height: userImageView.frame.height)
        userImageView.layer.addSublayer(border)
        
        // rounded corners
        userImageView.layer.cornerRadius = 10
        userImageView.layer.masksToBounds = true
        userImageView.clipsToBounds = true
    }
    
    
    // takes us to the PickerController (Controller that allows us to select picture)
    func showPicker(with source: UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = source
        present(picker, animated: true, completion: nil)
        
    }
    
    
    // executed when Cover is tapped
    @IBAction func coverImageView_tapped(_ sender: Any) {
        
        // switching trigger
        imageViewTapped = .Cover
        
        // launch action sheet calling function
        showActionSheet()
    }
    
    
    // executed when user is tapped
    @IBAction func userImageView_tapped(_ sender: Any) {
        
        // switching trigger
        imageViewTapped = .UserImage
        
        // launch action sheet calling function
        showActionSheet()
    }
    
    @IBAction func updateBio_tapped(_ sender: Any) {
  
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // declaring New Bio button
        let bio = UIAlertAction(title: "New Bio", style: .default) { (action) in
            
            // go to Bio Page
            guard let bioVC = self.storyboard?.instantiateViewController(withIdentifier: "BioVC") as? BioVC else { return }
            let navController = UINavigationController(rootViewController: bioVC)
            bioVC.delegate = self
            self.present(navController, animated: true, completion: nil)
            
        }
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // adding buttons to the sheet
        sheet.addAction(bio)
        sheet.addAction(cancel)
        // declaring delete button
        if userBioLabel.text?.characters.count != 0 {
            let delete = UIAlertAction(title: "Delete Bio", style: .destructive) {[weak self](action) in
                
                guard let `self` = self else {return}
                
                // send blank bio to the server
                let bioData = UpdateBioRequiredInfo(bioData: String())
                self.homeAPIInteractor.updateBioData(with: bioData) {[weak self] (response) in
                    guard let `self` = self else {return}
                    if response.statusCode == "200" {
                        DispatchQueue.main.async {
                            self.userBioLabel.text = CustomerProfile.shared.userBio
                            self.editBioButton.setTitle("Add Temporary Bio", for: .normal)
                        }
                    }
                }
            }
            sheet.addAction(delete)
        }

        
        
        
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
    }
    
    
    // this function launches Action Sheet for the photos
    func showActionSheet() {
        
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        // declaring camera button
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            
            // if camera userilable on device, than show
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.showPicker(with: .camera)
            }
            
        }
        
        
        // declaring library button
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            
            // checking userilability of photo library
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.showPicker(with: .photoLibrary)
            }
            
        }
        
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        // declaring delete button
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            
            // deleting profile picture (user), by returning placeholder
            if self.imageViewTapped == .UserImage {
                self.userImageView.image = UIImage(named: "user.png")
                self.isUserImageTapped = false
            } else if self.imageViewTapped == .Cover {
                self.coverImageView.image = UIImage(named: "HomeCover.jpg")
                self.isCoverImageTapped = false
            }
            
        }
        
        
        // manipulating appearance of delete button for each scenarios
        if imageViewTapped == .UserImage && isUserImageTapped == false {
            delete.isEnabled = false
        } else if imageViewTapped == .Cover && isCoverImageTapped == false {
            delete.isEnabled = false
        }
        
        
        // adding buttons to the sheet
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        sheet.addAction(delete)
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    // executed once the picture is selected in PickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // access image selected from pickerController
        let image = info[UIImagePickerControllerEditedImage] as? UIImage
        
        // based on the trigger we are assigning selected pictures to the appropriated imageView
        if imageViewTapped == .Cover {
            
            // assign selected image to CoverImageView
            self.coverImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: self.coverImageView)
            
        } else if imageViewTapped == .UserImage {
            
            // assign selected image to AvaImageView
            self.userImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: userImageView)
            
        }
        
        // completion handler, to communicate to the project that images has been selected (enable delete button)
        dismiss(animated: true) {
            if self.imageViewTapped == .Cover {
                self.isCoverImageTapped = true
            } else if self.imageViewTapped == .UserImage {
                self.isUserImageTapped = true
            }
        }
        
    }
    
    
    // sends request to the server to upload the Image (ava/cover)
    func uploadImage(from imageView: UIImageView) {
        
        // if in the imageView is placeholder - send no picture to the server
        // Compressing image and converting image to 'Data' type
        var imageData = Data()
        
        if imageView.image != UIImage(named: "HomeCover.jpg") && imageView.image != UIImage(named: "userImage.png") {
            imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)!
        }
        
        let uploadImageData = UploadImageRequiredInfo(imgData: imageData, imgType: imageViewTapped)
        
        homeAPIInteractor.uploadImage(with: uploadImageData) { (response) in
            print(response)
        }   
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}

extension HomeVC : HomeVCDelegate {
    func updateUserInfo() {
        DispatchQueue.main.async {
            self.userBioLabel.text = CustomerProfile.shared.userBio
            self.editBioButton.setTitleColor(UIColor.clear, for: .normal)
        }
    }
}
