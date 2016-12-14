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
        if let userID = Defaults.userID.getString() {
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
            self.userManager.removeUserIDDefaults()
            self.showLoginStoryboard()
        }
        alertController.addAction(logoutAction)
        let cancelAction = UIAlertAction(title: NSLocalizedString("ButtonTitleCancel", comment: ""), style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func showLoginStoryboard() {
        let mainStoryboard = UIStoryboard(name: "Login", bundle: nil)
        if let loginVC = mainStoryboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
            LoadingIndicatorView.hide()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
    }
    
    private func showCategoryViewController() {
        let mainStoryboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        if let listEditCategoryViewController = mainStoryboard.instantiateViewControllerWithIdentifier("ListEditCategoryViewController") as? ListEditCategoryViewController {
            self.navigationController?.pushViewController(listEditCategoryViewController, animated: true)
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
