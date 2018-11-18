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
    @IBOutlet weak var contentView_height: NSLayoutConstraint!
    @IBOutlet weak var contentSubviews_width: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        contentView_width.constant = self.view.frame.width * 7
        contentView_height.constant = self.view.frame.height
        contentSubviews_width.constant = self.view.frame.width
        setFieldsCornerRadius()
        
        //Set Delegates
    
        emailOrMobileTextField.addTarget(self, action: #selector(RegisterVC.emailTextFieldDidChange(_:)),
                            for: UIControlEvents.editingChanged)
        
         datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())
        datePicker.addTarget(self, action: #selector(datePickerDidChanged(_:)), for: .valueChanged)
        bdayTextField.inputView = datePicker
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
        emailOrLabelButton.backgroundColor = UIColor.init(red: 66/255, green: 103/255, blue: 178/255, alpha: 1)
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
    
   @objc func datePickerDidChanged(_ datePicker: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        bdayTextField.text = formatter.string(from: datePicker.date)
    
        let compareDateFormatter = DateFormatter()
        compareDateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        let compareDate = compareDateFormatter.date(from: "2013/01/01 00:01")
    
        if datePicker.date < compareDate! {
            bdayContinueButton.isHidden = false
        } else {
            bdayContinueButton.isHidden = true
        }
    }
    
    @IBAction func textFieldDidChanged(_ textField: UITextField) {
        
            // declaring constant (shortcut) to the Helper Class
            let helper = Helper()
            
            // logic for Email TextField
            if textField == emailOrMobileTextField {
                
                // check email validation
                if helper.isValid(email: emailOrMobileTextField.text!) {
                    emailOrLabelButton.isHidden = false
                }
                
                // logic for First Name or Last Name TextFields
            } else if textField == firstNameTextField || textField == surNameTextField {
                
                // check fullname validation
                if helper.isValid(name: firstNameTextField.text!) && helper.isValid(name: surNameTextField.text!) {
                    nameContinueButton.isHidden = false
                }
                
                // logic for Password TextField
            } else if textField == passwordTextField {
                
                // check password validation
                if passwordTextField.text!.count >= 6 {
                    passwordContinueButton.isHidden = false
                }
            }
            
        
        
        
    }
    //MARK: Get Started View - Outlets - Actions
    
    @IBOutlet weak var getStartedButton: UIButton!
    
    @IBAction func getStartedButton_tapped(_ sender: Any) {
        let position = CGPoint(x:self.view.frame.width, y:0)
        scrollView.setContentOffset(position, animated: true)
    }
    
    //MARK: Name View - Outlets - Actions
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var surNameTextField: UITextField!
    @IBOutlet weak var nameContinueButton: UIButton!
    
    @IBAction func nameContinueButton_tapped(_ sender: Any) {
        let position = CGPoint(x:self.view.frame.width * 2, y:0)
        scrollView.setContentOffset(position, animated: true)
    }
    
    //MARK: Bday View - Outlets - Actions
    
    @IBOutlet weak var bdayContinueButton: UIButton!
    @IBOutlet weak var bdayTextField: UITextField!
    
    @IBAction func bdayContinueButton_Tapped(_ sender: Any) {
        let position = CGPoint(x:self.view.frame.width * 3, y:0)
        scrollView.setContentOffset(position, animated: true)
    }
    
    //MARK: Gender View - Outlets - Actions
    
    @IBOutlet weak var femaleImageButton: UIButton!
    @IBOutlet weak var maleImageButton: UIButton!
    var selectedGender = 0
    @IBAction func genderButtonTapped(_ sender: UIButton) {
        selectedGender = sender.tag
        let position = CGPoint(x:self.view.frame.width * 4, y:0)
        scrollView.setContentOffset(position, animated: true)
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
        let helper = Helper()
        if helper.isValid(name: emailOrMobileTextField.text!) {
            
        }
        let position = CGPoint(x:self.view.frame.width * 5, y:0)
        scrollView.setContentOffset(position, animated: true)
        
    }
    //MARK: Password View - Outlets - Actions
    
    @IBOutlet weak var passwordContinueButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func passwordContinueButtonTapped(_ sender: Any) {
        let position = CGPoint(x:self.view.frame.width * 6, y:0)
        scrollView.setContentOffset(position, animated: true)
    }
    
    
    //MARK: Password View - Outlets - Actions
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        // STEP 1. Declaring URL of the request; declaring the body to the URL; declaring request with the safest method - POST, that no one can grab our info.
        let url = URL(string: "http://localhost/fb/register.php")!
        let body = "email=\(emailOrMobileTextField.text!.lowercased())&firstName=\(firstNameTextField.text!.lowercased())&lastName=\(surNameTextField.text!.lowercased())&password=\(passwordTextField.text!.lowercased())&birthday=\(bdayTextField.text!.lowercased())&gender=\(selectedGender)"
        var request = URLRequest(url: url)
        request.httpBody = body.data(using: .utf8)
        request.httpMethod = "POST"
        print(url)
        // STEP 2. Execute created above request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // access helper class
            let helper = Helper()
            
            // error
            if error != nil {
                helper.showAlert(title: "Server Error", message: error!.localizedDescription, in: self)
                return
            }
            
            // fetch JSON if no error
            do {
                
                // save mode of casting data
                guard let data = data else {
                    helper.showAlert(title: "Data Error", message: error!.localizedDescription, in: self)
                    return
                }
                
                // fetching all JSON received from the server
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
                
                print(json)
                
                // error while fetching JSON
            } catch {
                helper.showAlert(title: "JSON Error", message: error.localizedDescription, in: self)
            }
            
            
            }.resume()

        self.dismiss(animated: true, completion: nil)
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
