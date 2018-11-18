//
//  HomeVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/18/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class HomeVC: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    // ui obj
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    
    // code obj (to build logic of distinguishing tapped / shown Cover / user)
    var isCoverImageTapped = false
    var isUserImageTapped = false
    var imageViewTapped = ""
    
    
    
    // first load func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // run funcs
        configure_userImageView()
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
        imageViewTapped = "cover"
        
        // launch action sheet calling function
        showActionSheet()
    }
    
    
    // executed when user is tapped
    @IBAction func userImageView_tapped(_ sender: Any) {
        
        // switching trigger
        imageViewTapped = "userImage"
        
        // launch action sheet calling function
        showActionSheet()
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
            if self.imageViewTapped == "userImage" {
                self.userImageView.image = UIImage(named: "user.png")
                self.isUserImageTapped = false
            } else if self.imageViewTapped == "cover" {
                self.coverImageView.image = UIImage(named: "HomeCover.jpg")
                self.isCoverImageTapped = false
            }
            
        }
        
        
        // manipulating appearance of delete button for each scenarios
        if imageViewTapped == "userImage" && isUserImageTapped == false {
            delete.isEnabled = false
        } else if imageViewTapped == "cover" && isCoverImageTapped == false {
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
        if imageViewTapped == "cover" {
            
            // assign selected image to CoverImageView
            self.coverImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: self.coverImageView)
            
        } else if imageViewTapped == "userImage" {
            
            // assign selected image to AvaImageView
            self.userImageView.image = image
            
            // upload image to the server
            self.uploadImage(from: userImageView)
            
        }
        
        // completion handler, to communicate to the project that images has been selected (enable delete button)
        dismiss(animated: true) {
            if self.imageViewTapped == "cover" {
                self.isCoverImageTapped = true
            } else if self.imageViewTapped == "userImage" {
                self.isUserImageTapped = true
            }
        }
        
    }
    
    
    // sends request to the server to upload the Image (ava/cover)
    func uploadImage(from imageView: UIImageView) {
        
        // save method of accessing ID of current user
        guard let id = currentUser?["id"] else {
            return
        }
        
        // STEP 1. Declare URL, Request and Params
        // url we gonna access (API)
        let url = URL(string: "http://192.168.1.67/fb/uploadImage.php")!
        
        // declaring reqeust with further configs
        var request = URLRequest(url: url)
        
        // POST - safest method of passing data to the server
        request.httpMethod = "POST"
        
        // values to be sent to the server under keys (e.g. ID, TYPE)
        let params = ["id": id, "type": imageViewTapped]
        
        // MIME Boundary, Header
        let boundary = "Boundary-\(NSUUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // if in the imageView is placeholder - send no picture to the server
        // Compressing image and converting image to 'Data' type
        var imageData = Data()
        
        if imageView.image != UIImage(named: "HomeCover.jpg") && imageView.image != UIImage(named: "userImage.png") {
            imageData = UIImageJPEGRepresentation(imageView.image!, 0.5)!
        }
        
        // assigning full body to the request to be sent to the server
        request.httpBody = Helper().body(with: params, filename: "\(imageViewTapped).jpg", filePathKey: "file", imageDataKey: imageData, boundary: boundary) as Data
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
                // error occured
                if error != nil {
                    Helper().showAlert(title: "Server Error", message: error!.localizedDescription, in: self)
                    return
                }
                
                
                do {
                    
                    // save mode of casting any data
                    guard let data = data else {
                        Helper().showAlert(title: "Data Error", message: error!.localizedDescription, in: self)
                        return
                    }
                    
                    // fetching JSON generated by the server - php file
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                    
                    guard let parsedJSON = json else {
                        return
                    }
                    
                    if parsedJSON["status"] as! String == "200" {
                        currentUser = parsedJSON.mutableCopy() as? NSMutableDictionary
                        UserDefaults.standard.set(currentUser, forKey: "currentUser")
                        UserDefaults.standard.synchronize()
                    } else {
                        if parsedJSON["message"] != nil {
                            let message = parsedJSON["message"] as! String
                            Helper().showAlert(title: "Error", message: message, in: self)
                        }
                    }
                    
                } catch {
                    Helper().showAlert(title: "JSON Error", message: error.localizedDescription, in: self)
                }
                
            }
            }.resume()
        
        
    }
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}
