//
//  RegisterViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 11/24/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var loginSegmentControl: UISegmentedControl!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton?.round(6, borderWith: 0, borderColor: UIColor.blueColor().CGColor)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func changeItemAction(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            loginButton?.setTitle("Đăng ký", forState: .Normal)
        } else {
            loginButton?.setTitle("Đăng nhập", forState: .Normal)
        }
    }
    
    @IBAction func loginAction(sender: AnyObject) {
        if loginSegmentControl.selectedSegmentIndex == 0 {
            register()
        } else {
            login()
        }
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func login() {
        print("Login")
    }
    
    private func register() {
        if let email = emailTextField?.text, let password = passwordTextField?.text {
            if email.isBlank || password.isBlank {
                presentAlertWithTitle("Error", message: "Email or Password not empty")
            } else if password.characters.count < 6 {
                presentAlertWithTitle("Error", message: "Password more than 6 letters")
            } else if email.isEmail {
                presentAlertWithTitle("Error", message: "Email invalid")
            } else if password.isCheckSpecialCharacter {
                presentAlertWithTitle("Error", message: "Password invalid")
            } else {
                if userManager.checkUserExisted(email) {
                    presentAlertWithTitle("Error", message: "Email was exist")
                } else {
                    if userManager.addUser(email, password: password) {
                        presentAlertWithTitle("Success", message: "You have successfully registered")
                        loginSegmentControl.selectedSegmentIndex = 1
                        loginButton?.setTitle("Đăng nhập", forState: .Normal)
                    } else {
                        presentAlertWithTitle("Error", message: "Can't save user")
                    }
                }
            }
        }
    }
}
