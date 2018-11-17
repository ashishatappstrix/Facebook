//
//  RegisterVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/16/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var contentView_width: NSLayoutConstraint!
    @IBOutlet weak var contentSubviews_width: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView_width.constant = self.view.frame.width * 7
        contentSubviews_width.constant = self.view.frame.width
        setFieldsCornerRadius()
        
        //Set Delegates
    
        emailOrMobileTextField.addTarget(self, action: #selector(RegisterVC.emailTextFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButtonBorders(for: [maleImageButton, femaleImageButton])
    }
    

    @IBAction func alreadyHaveAccountTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setFieldsCornerRadius() {
        setCornerRadius(for: getStartedButton)
        setCornerRadius(for: firstNameTextField)
        setCornerRadius(for: surNameTextField)
        setCornerRadius(for: nameContinueButton)
        setCornerRadius(for: bdayContinueButton)
        setCornerRadius(for: emailOrMobileTextField)
        setCornerRadius(for: emailAddressButton)
        setCornerRadius(for: passwordTextField)
        setCornerRadius(for: signupButton)
    }
    
    func setCornerRadius(for view:UIView) {
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
    }
    
    func addButtonBorders(for buttons: [UIButton]) {
        
        for button in buttons {
            let border = CALayer()
            border.borderWidth = 2
            border.borderColor = UIColor.lightGray.cgColor
            border.frame = CGRect(x: 0, y: 0, width: button.frame.width, height: button.frame.height)
            button.layer.addSublayer(border)
            button.layer.cornerRadius = 5
            button.layer.masksToBounds = true
        }
    }
    
    func setEmailContinueButton() {
        emailOrLabelButton.setTitle("Continue", for: .normal)
        emailOrLabelButton.backgroundColor = UIColor.blue
        emailOrLabelButton.setTitleColor(.white, for: .normal)
    }
    
    func setLabelTextForEmailView() {
        if isButtonTextEmail {
            emailOrMobileTextLabel.text = "What's your email address?"
            emailOrLabelButton.setTitle("You'll use this email address when you log in and if you ever need to reset your password", for: .normal)
            emailAddressButton.setTitle("Use your mobile numer", for: .normal)
            
            isButtonTextEmail = false
            
        } else {
            emailOrMobileTextLabel.text = "What's your mobile number?"
            emailOrLabelButton.setTitle("You'll use this number when you log in and if you ever need to reset your password", for: .normal)
            emailAddressButton.setTitle("Use your email address", for: .normal)
            
            isButtonTextEmail = true
        }
    }
    
    //MARK: Get Started View - Outlets - Actions
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBAction func getStartedButton_tapped(_ sender: Any) {
        
    }
    
    //MARK: Name View - Outlets - Actions
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var nameContinueButton: UIButton!
    
    @IBAction func nameContinueButton_tapped(_ sender: Any) {
        
    }
    
    //MARK: Bday View - Outlets - Actions
    
    @IBOutlet weak var bdayContinueButton: UIButton!
    
    @IBAction func bdayContinueButton_Tapped(_ sender: Any) {
    }
    
    //MARK: Gender View - Outlets - Actions
    
    @IBOutlet weak var femaleImageButton: UIButton!
    @IBOutlet weak var maleImageButton: UIButton!
    
    @IBAction func maleImageButtonTapped(_ sender: Any) {
    }
    
    @IBAction func femaleImageButtonTapped(_ sender: Any) {
    }
    
    //MARK: Mobile/Email Number View - Outlets - Actions
    
    @IBOutlet weak var emailOrMobileTextLabel: UILabel!
    @IBOutlet weak var emailOrMobileTextField: UITextField!
    @IBOutlet weak var emailAddressButton: UIButton!
    @IBOutlet weak var emailOrLabelButton: UIButton!
    
    var isButtonTextEmail = true
    @IBAction func emailAddressButtonTapped(_ sender: Any) {
       setLabelTextForEmailView()
    }
    

    
    @IBAction func emailOrLabelButtonTapped(_ sender: Any) {
        
        
    }
    //MARK: Password View - Outlets - Actions
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    //MARK: Password View - Outlets - Actions
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        
    }
}

extension RegisterVC {
    
    @objc func emailTextFieldDidChange(_ textField: UITextField) {
        if textField.text?.characters.count != 0 {
            setEmailContinueButton()
        } else {
            self.setLabelTextForEmailView()
        }
    }
}
