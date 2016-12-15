//
//  ChooseWalletTableViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/5/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol ReloadDataFromChooseWalletDelegate: class {
    func reloadDataFromChooseWallet()
}

class ChooseWalletTableViewController: UITableViewController {
    
    var dataWallet = [WalletModel]()
    var walletManager = WalletManager()
    weak var delegate: ReloadDataFromChooseWalletDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TitleChooseWallet", comment: "")
        dataWallet.appendContentsOf(self.walletManager.getAllWallet())
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func addAction(sender: AnyObject) {
        if let addWalletVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddWalletViewcontroller") as? AddWalletTableViewController {
            addWalletVC.delegate = self
            self.navigationController?.pushViewController(addWalletVC, animated: true)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataWallet.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as? WalletTableViewCell {
            let wallet = dataWallet[indexPath.row]
            cell.walletNameLabel.text = wallet.name
            cell.iconImageView.image = UIImage(named: wallet.iconName)
            cell.moneyLabel.text = "\(wallet.amount ?? 0.0)"
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return NSLocalizedString("HeaderTitleChooseWallet", comment: "")
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.selected = false
        if let addWalletVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddWalletViewcontroller") as? AddWalletTableViewController {
            addWalletVC.delegate  = self
            addWalletVC.wallet = dataWallet[indexPath.row]
            self.navigationController?.pushViewController(addWalletVC, animated: true)
        }
    }
}

extension ChooseWalletTableViewController: ReloadDataFromAddWalletTVCDelegate {
    func reloadData() {
        self.dataWallet.removeAll()
        self.dataWallet.appendContentsOf(self.walletManager.getAllWallet())
        self.tableView.reloadData()
        self.delegate?.reloadDataFromChooseWallet()
    }
}
