//
//  BioVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/25/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class BioVC: UIViewController {

    @IBOutlet weak var userDP: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var whatsNewLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    
    let homeAPIInteractor = HomeAPIInteractor()
    var delegate : HomeVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDPView()
        Helper().downloadImage(path: CustomerProfile.shared.userDisplayImageURL, showIn: userDP, orShow: "user.png")
        userName.text =  Helper().getUserFullname()
    }

    func configureDPView() {
        userDP.layer.cornerRadius = userDP.frame.width / 2
        userDP.clipsToBounds = true
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        if bioTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty == false {
            let bioData = UpdateBioRequiredInfo(bioData: bioTextView.text)
            homeAPIInteractor.updateBioData(with: bioData) {[weak self] (response) in
                if response.statusCode == "200" {
                    if self?.delegate != nil {
                        self?.delegate?.updateUserInfo()
                    }
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension BioVC: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        
        let allowed = 101
        let typed = textView.text.count
        let remaining = allowed - typed
        
        counterLabel.text = "\(remaining)/101"
        self.whatsNewLabel.isHidden = !textView.text.isEmpty
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        guard text.rangeOfCharacter(from: CharacterSet.newlines) == nil else {
            return false
        }
        
        return textView.text.count + (text.count - range.length) <= 101
    }
}
