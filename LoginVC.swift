//
//  LoginVC.swift
//  FaceBook
//
//  Created by Ashish Shaik on 11/16/18.
//  Copyright © 2018 Ashish Shaik. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var textFieldsView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func viewDidLayoutSubviews() {
        //Configure View Elements
        configureTextFieldsView()
        configureLoginButton()
        configureRegisterButton()
    }
    
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
