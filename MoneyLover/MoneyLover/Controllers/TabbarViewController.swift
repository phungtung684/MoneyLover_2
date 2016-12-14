//
//  TabbarViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/13/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationStyle()
        self.addWalletBarButtonItem("icon_94")
    }
    
    private func navigationStyle() {
        self.tabBar.tintColor = UIColor(red: 30.0 / 255, green: 188.0 / 255, blue: 94.0 / 255, alpha: 1)
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barStyle = .BlackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
    }
    
    private func addWalletBarButtonItem(iconName: String) {
        let button = UIButton()
        button.setImage(UIImage(named: iconName), forState: .Normal)
        button.addTarget(self, action: #selector(walletButtonAction), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.round(15, borderWith: 1, borderColor: UIColor.blackColor().CGColor)
        button.layer.masksToBounds = true
        let walletButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = walletButton
    }
    
    @objc func walletButtonAction() {
        if let selectWalletTableController = self.storyboard?.instantiateViewControllerWithIdentifier("SelectWalletTableController") as? SelectWalletTableViewController {
            selectWalletTableController.changeCurrentWalletDelegate = self
            let navigationController = UINavigationController(rootViewController: selectWalletTableController)
            navigationController.navigationBar.translucent = false
            navigationController.navigationBar.barStyle = .BlackTranslucent
            navigationController.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
            navigationController.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
            self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension TabbarViewController: ChangeCurrentWalletDelegate {
    func changeCurrentWallet(walletModel: WalletModel) {
        self.addWalletBarButtonItem(walletModel.iconName)
    }
}
