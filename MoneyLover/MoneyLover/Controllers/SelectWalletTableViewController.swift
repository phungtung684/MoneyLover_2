//
//  SelectWalletTableViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/13/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class SelectWalletTableViewController: UITableViewController {
    
    var dataWallet = [WalletModel]()
    var dataStored = DataStored()
    var walletManager = WalletManager()
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("ChooseWalletTitle", comment: "")
        let buttonEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(saveAction))
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = buttonEdit
        navigationItem.leftBarButtonItem = buttonCancel
        self.getdataFromDB()
        self.tableView.registerNib(UINib(nibName: "SelecWalletTableViewCell", bundle: nil), forCellReuseIdentifier: "SelectCell")
    }
    
    @objc private func saveAction() {
        if let chooseWalletTableViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseWalletTVC") as? ChooseWalletTableViewController {
            self.navigationController?.pushViewController(chooseWalletTableViewController, animated: true)
        }
        
    }
    
    @objc private func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getdataFromDB() {
        let listWallet = dataStored.fetchRecordsForEntity("Wallet", inManagedObjectContext: managedObjectContext)
        if listWallet.count == 0 {
            for wallet in ListWalletAvalable().listWallet {
                if let w = walletManager.addWalletAvailable(wallet) {
                    dataWallet.append(WalletModel(wallet: w))
                }
            }
        } else {
            for item in listWallet {
                if let wallet = item as? Wallet {
                    dataWallet.append(WalletModel(wallet: wallet))
                }
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return dataWallet.count
        }
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 60
        } else if indexPath.section == 1 {
            return 50
        }
        return 44
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier("SelectCell", forIndexPath: indexPath) as? SelecWalletTableViewCell {
            if indexPath.section == 0 {
                cell.iconImageView.image = UIImage(named: "ic_category_all")
                cell.nameWalletLabel.text = NSLocalizedString("Total", comment: "")
                var totalAmount = 0.0
                for item in dataWallet {
                    totalAmount += item.amount
                }
                cell.amountWalletLabel.text = "\(totalAmount)"
                cell.accessoryType = .Checkmark
                return cell
            } else if indexPath.section == 1 {
                let walletModel = dataWallet[indexPath.row]
                cell.nameWalletLabel.text = walletModel.name
                cell.amountWalletLabel.text = "\(walletModel.amount)"
                cell.iconImageView.image = UIImage(named: walletModel.iconName)
                return cell                
            } else if indexPath.section == 2 {
                let actionCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                actionCell.imageView?.image = UIImage(named: "ic_add_circle")
                actionCell.textLabel?.text = NSLocalizedString("TitleActionCell", comment: "")
                actionCell.textLabel?.textColor = UIColor.greenColor()
                return actionCell
                
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return NSLocalizedString("HeaderTitleChooseWallet", comment: "")
        }
        return ""
    }
}
