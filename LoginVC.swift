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
    
    //Constraints
    @IBOutlet weak var coverImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var handsImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteImageYConstraint: NSLayoutConstraint!
    
    //MARK: View Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
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
        coverImageTopConstraint.constant -= 75
        handsImageTopConstraint.constant -= 75
        whiteImageYConstraint.constant += 50
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("Begin: \(keyboardSize.height)")
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
        coverImageTopConstraint.constant += 75
        handsImageTopConstraint.constant += 75
        whiteImageYConstraint.constant -= 50
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            print("End: \(keyboardSize.height)")
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
        loginButton.isEnabled = false
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
}
