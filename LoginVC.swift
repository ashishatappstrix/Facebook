//
//  LoginVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/16/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //UI Objects
    @IBOutlet weak var handsImageView: UIImageView!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var textFieldsView: UIView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    //Constraints
    @IBOutlet weak var coverImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var handsImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteImageYConstraint: NSLayoutConstraint!
    
    let accountsAPIInteractor = AccountsAPIInteractor()
    
    //MARK: View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //TODO: Cache constraints and load initial values in keyboard notification methods
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Notification while displaying/hiding keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLayoutSubviews() {
        //Configure View Elements
        configureTextFieldsView()
        configureLoginButton()
        configureRegisterButton()
    }
    
    //MARK: Keyboard Show/Hide Implementation
    
    //Actions while showing keyboard
    @objc func keyboardWillShow(notification: Notification) {
        //Reduce size by 75px
        //TODO: Convert to dynamic values
        coverImageTopConstraint.constant -= 75
        handsImageTopConstraint.constant -= 75
        whiteImageYConstraint.constant += 50
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            registerButtonBottomConstraint.constant += keyboardSize.height
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else { return }
            self.handsImageView.alpha = 0
            self.view.layoutIfNeeded()
        }
    }
    
    //Actions while hiding keyboard
    @objc func keyboardWillHide(notification: Notification) {
        //Increase size by 75px
        //TODO: Convert to dynamic values
        coverImageTopConstraint.constant += 75
        handsImageTopConstraint.constant += 75
        whiteImageYConstraint.constant -= 50
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            registerButtonBottomConstraint.constant -= keyboardSize.height
        }
        UIView.animate(withDuration: 0.5) { [weak self] in
            guard let `self` = self else { return }
            self.handsImageView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    //Hide keyboard when tapped on white space
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    //MARK: UI Configuration
    //Configures appearance of textview
    func configureTextFieldsView() {
        let border = CALayer()
        let width = CGFloat(2)
        let color = UIColor.groupTableViewBackground.cgColor
        
        //creating layer to the border of the view
        border.borderColor = color
        border.frame = CGRect(x: 0, y: 0, width: textFieldsView.frame.width, height: textFieldsView.frame.height)
        border.borderWidth = width
        
        //creating outline of textview
        let line = CALayer()
        line.borderWidth = width
        line.borderColor = color
        line.borderWidth = width
        line.frame = CGRect(x: 0, y: textFieldsView.frame.height / 2 - width, width: textFieldsView.frame.width, height: width)
        
        //add border and line
        textFieldsView.layer.addSublayer(border)
        textFieldsView.layer.addSublayer(line)
        
        //corner radius
        textFieldsView.layer.cornerRadius = 5
        textFieldsView.layer.masksToBounds = true
    }
    
    //Configure Login Button Appearance
    func configureLoginButton() {
        loginButton.layer.cornerRadius = 5
        loginButton.layer.masksToBounds = true
    }
    
    //Configure Register Button
    func configureRegisterButton() {
        let border = CALayer()
        border.borderWidth = 2
        border.borderColor = UIColor(red: 68/255, green: 105/255, blue: 176/255, alpha: 0.5).cgColor
        border.frame = CGRect(x: 0, y: 0, width: registerButton.frame.width, height: registerButton.frame.height)
        registerButton.layer.addSublayer(border)
        
        registerButton.layer.cornerRadius = 5
        registerButton.layer.masksToBounds = true
    }
    
    
    @IBAction func loginButton_Tapped(_ sender: Any) {
        // accessing Helper Class that stores multi-used functions
        let helper = Helper()
        
        // 1st Varification: if etnered text in EmailTextField doesn't match our expression/rule, show alert
        if helper.isValid(email: emailTextField.text!) == false {
            helper.showAlert(title: "Invalid Email", message: "Please enter registered Email address", in: self)
            return
            
            // 2nd Varification: if password is less than 6 chars, then return do not executed further
        } else if passwordTextField.text!.count < 6 {
            helper.showAlert(title: "Invalid Password", message: "Password must contain at least 6 characters", in: self)
            return
        }
        
        // run LoginRequest Function
        loginRequest()
    }
    
    // sending request to the server for proceeding Log In
    func loginRequest() {
        let loginData = LoginRequiredInfo(userName: emailTextField.text!, password: passwordTextField.text!)
        accountsAPIInteractor.getLoginStatus(with: loginData) { (response) in
            if response.statusCode == "200" {
                DispatchQueue.main.async {
                    let helper = Helper()
                    print("Module Manager: \(CustomerProfile.shared.userEmail)")
                    helper.instantiateViewController(identifier: "TabBar", animated: true, by: self, completion: nil)
                }
            }
        }
    }
}
