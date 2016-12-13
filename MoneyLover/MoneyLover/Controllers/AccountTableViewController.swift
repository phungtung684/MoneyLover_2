//
//  AccountTableViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/2/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class AccountTableViewController: UITableViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    var userManager = UserManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TitleAccount", comment: "")
        if let userID = NSUserDefaults.standardUserDefaults().stringForKey("userID") {
            emailLabel?.text = userID
        }
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .Done, target: self, action: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logoutAction(sender: AnyObject) {
        let alertController = UIAlertController(title: NSLocalizedString("LogoutConfirmTitle", comment: ""), message: NSLocalizedString("LogoutConfirmMessage", comment: ""), preferredStyle: .Alert)
        let logoutAction = UIAlertAction(title: NSLocalizedString("ButtonTitleLogout", comment: ""), style: .Default) { (logoutaction) in
            LoadingIndicatorView.show(self.tableView, loadingText: NSLocalizedString("TitleLoadingIndicator", comment: ""))
            self.userManager.logout()
            self.showLoginStoryboard()
        }
        alertController.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ButtonTitleCancel", comment: ""), style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showLoginStoryboard() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
            if let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                appDelegate.window?.rootViewController = loginVC
                LoadingIndicatorView.hide()
                appDelegate.window?.makeKeyAndVisible()
            }
        }
    }
    
    private func showCategoryViewController() {
        let mainStoryboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        if let addTransactionVC = mainStoryboard.instantiateViewControllerWithIdentifier("AddTransactionViewController") as? AddTransactionViewController {
            self.navigationController?.pushViewController(addTransactionVC, animated: true)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 1 {
                self.showCategoryViewController()
            }
        }
    }
}
