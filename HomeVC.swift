//
//  HomeVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/18/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class HomeVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func coverImageVIew_tapped(_ sender: Any) {
        // launch action sheet calling function
        showActionSheet()
    }
    
  
    @IBAction func userImageView_tapped(_ sender: Any) {
        // launch action sheet calling function
        showActionSheet()
    }
    
    
    // this function launches Action Sheet for the photos
    func showActionSheet() {
        
        // declaring action sheet
        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // declaring camera button
        let camera = UIAlertAction(title: "Camera", style: .default) { (action) in
            print("Go to camera")
        }
        
        // declaring library button
        let library = UIAlertAction(title: "Photo Library", style: .default) { (action) in
            print("Go to Library")
        }
        
        // declaring cancel button
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // declaring delete button
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
            print("Deleted")
        }
        
        // adding buttons to the sheet
        sheet.addAction(camera)
        sheet.addAction(library)
        sheet.addAction(cancel)
        sheet.addAction(delete)
        
        // present action sheet to the user finally
        self.present(sheet, animated: true, completion: nil)
        
    }
    
    
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    
}
