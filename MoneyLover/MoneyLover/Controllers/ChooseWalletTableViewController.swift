//
//  ChooseWalletTableViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/5/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class ChooseWalletTableViewController: UITableViewController {
    
    var dataWallet = [Wallet]()
    var dataStored = DataStored()
    
    var walletManager = WalletManager()
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("TitleChooseWallet", comment: "")
        self.getdataFromDB()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getdataFromDB() {
        let listWallet = dataStored.fetchRecordsForEntity("Wallet", inManagedObjectContext: managedObjectContext)
        if listWallet.count == 0 {
            for wallet in ListWalletAvalable().listWallet {
                if let w = walletManager.addWalletAvailable(wallet) {
                    dataWallet.append(w)
                }
            }
        } else {
            for item in listWallet {
                if let wallet = item as? Wallet {
                    dataWallet.append(wallet)
                }
            }
        }
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
            if let iconImageName = wallet.icon {
                cell.iconImageView.image = UIImage(named: iconImageName)
            } else {
                cell.iconImageView.image = UIImage(named: wallet.icon ?? "icon_109")
            }
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

extension ChooseWalletTableViewController: AddWalletTableViewControllerDelegate {
    func reloadData() {
        dispatch_async(dispatch_get_main_queue(), {
            self.dataWallet.removeAll()
            self.getdataFromDB()
            self.tableView.reloadData()
        })
    }
}
