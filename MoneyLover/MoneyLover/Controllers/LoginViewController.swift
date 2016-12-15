//
//  ViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 11/22/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import Google

class LoginViewController: UIViewController, GIDSignInUIDelegate {
    
    var scrollView: UIScrollView!
    @IBOutlet weak var loginFBButton: UIButton!
    @IBOutlet weak var loginGoogleButton: UIButton!
    @IBOutlet weak var signinSignupEmailButton: UIButton!
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
    }
    
    private func setupView() {
        let scrollViewRect = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: (self.view.bounds.size.height * 2) / 3)
        self.scrollView = UIScrollView(frame: scrollViewRect)
        self.scrollView.pagingEnabled = true
        self.scrollView.contentSize = CGSize(width: scrollViewRect.size.width * 4.0, height: scrollViewRect.size.height)
        self.scrollView.backgroundColor = UIColor(red: 0.0/255.0, green: 199.0/255.0, blue: 83.0/255, alpha: 1)
        self.view.addSubview(scrollView)
        var imageViewRect = scrollViewRect
        var labelRect = CGRect(x: 0, y: imageViewRect.size.height - 40, width: imageViewRect.size.width, height: 30)
        let splashScreenData = SplashScreenData()
        for page in splashScreenData.dataPage {
            let textLabel = UILabel(frame: labelRect)
            textLabel.font = UIFont(name: textLabel.font?.fontName ?? "", size: 12)
            textLabel.textAlignment = NSTextAlignment.Center
            textLabel.numberOfLines = 0
            textLabel.textColor = UIColor.whiteColor()
            textLabel.text = page.description
            let imageViewPage = self.createImageView(UIImage(named: page.imageName), frame: imageViewRect)
            self.scrollView.addSubview(textLabel)
            self.scrollView.addSubview(imageViewPage)
            imageViewRect.origin.x += imageViewRect.size.width
            labelRect.origin.x += labelRect.size.width
        }
        loginFBButton?.round(5, borderWith: 1, borderColor: UIColor.blueColor().CGColor)
        loginGoogleButton?.round(5, borderWith: 1, borderColor: UIColor.redColor().CGColor)
        signinSignupEmailButton?.round(5, borderWith: 1, borderColor: UIColor.grayColor().CGColor)
    }
    
    @IBAction func loginFBAction(sender: AnyObject) {
        LoadingIndicatorView.show(self.view, loadingText: NSLocalizedString("TitleLoadingIndicator", comment: ""))
        FBSDKLoginManager().logInWithReadPermissions(["email"], fromViewController: self) { (result, error) in
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).startWithCompletionHandler({ (connection, result, error) in
                if let userFb = result as? [String: String] {
                    let email =  userFb["email"] ?? ""
                    if self.userManager.checkUserExisted(email) {
                        Defaults.userID.set(email)
                        self.showMainStoryboard()
                    } else {
                        if self.userManager.addUserFromSocial(email) {
                            self.showMainStoryboard()
                            
                        } else {
                            self.presentAlertWithTitle("Error", message: "Failed to add data to context")
                        }
                    }
                } else {
                    LoadingIndicatorView.hide()
                    self.presentAlertWithTitle("Message", message: "Can't connect Facebook")
                }
            })
        }
    }
    
    @IBAction func LoginGoogleAction(sender: AnyObject) {
        LoadingIndicatorView.show(self.view, loadingText: NSLocalizedString("TitleLoadingIndicator", comment: ""))
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func signinSignupEmailAction(sender: AnyObject) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func createImageView(paramImage: UIImage?, frame: CGRect) -> UIImageView {
        let result = UIImageView(frame: frame)
        result.contentMode = UIViewContentMode.ScaleAspectFit
        result.image = paramImage
        return result
    }
    
    private func showMainStoryboard() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let home = mainStoryboard.instantiateViewControllerWithIdentifier("TabbarController") as? UITabBarController {
            let nav = UINavigationController(rootViewController: home)
            self.presentViewController(nav, animated: true, completion: nil)
            LoadingIndicatorView.hide()
        }
    }
}

extension LoginViewController: GIDSignInDelegate {
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if error == nil {
            if self.userManager.checkUserExisted(user.profile.email) {
                Defaults.userID.set(user.profile.email)
                self.showMainStoryboard()
            } else {
                if self.userManager.addUserFromSocial(user.profile.email) {
                    self.showMainStoryboard()
                } else {
                    self.presentAlertWithTitle("Error", message: "Failed to add data to context")
                }
            }
        } else {
            LoadingIndicatorView.hide()
            self.presentAlertWithTitle("Message", message: "Can't connect Google")
        }
    }
}
