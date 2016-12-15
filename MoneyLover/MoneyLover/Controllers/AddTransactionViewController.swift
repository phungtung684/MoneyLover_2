//
//  AddTransactionViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/28/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class AddTransactionViewController: UITableViewController {
    
    @IBOutlet weak var inputAmountTextField: UITextField!
    @IBOutlet weak var nameWalletLabel: UILabel!
    @IBOutlet weak var iconWalletImageView: UIImageView!
    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var iconCategoryImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    var noteCurrent: String?
    var location: String?
    var dateCurrent = NSDate()
    var category: CategoryModel?
    var wallet: WalletModel?
    var walletManager = WalletManager()
    var transaction: TransactionModel?
    var transactionManager = TransactionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        showViewTransaction()
    }
    
    @objc private func saveAction() {
        if let transaction = transaction {
            print("edit \(transaction)")
        } else {
            if let category = category, let amount = inputAmountTextField?.text, let wallet = wallet {
                let transactionModel = TransactionModel()
                transactionModel.categoryWithTransaction = category
                transactionModel.walletWithTransaction = wallet
                transactionModel.date = dateCurrent
                transactionModel.location = location
                transactionModel.note = noteCurrent
                if let amount = Double(amount) {
                    transactionModel.amount = amount
                    if transactionManager.addTransaction(transactionModel) {
                        self.presentAlertWithTitle("Success", message: "OK.")
                    }
                } else {
                    self.presentAlertWithTitle("Error", message: "ReEnter Amount")
                }
            } else {
                self.presentAlertWithTitle("Error", message: "Check input!")
            }
        }
    }
    
    @objc private func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func showViewTransaction() {
        if let transaction = transaction {
            print("show information \(transaction)")
        } else {
            self.title = NSLocalizedString("TitleActionCell", comment: "")
        }
        let buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(saveAction))
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = buttonSave
        navigationItem.leftBarButtonItem = buttonCancel
        self.dateLabel?.text = dateCurrent.getFormatDate()
        inputAmountTextField?.keyboardType = .NumberPad
        if let walletModel = walletManager.getWalletByID(Defaults.currentWalletId.getString() ?? "") {
            wallet = walletModel
            iconWalletImageView?.image = UIImage(named: walletModel.iconName)
            nameWalletLabel?.text = walletModel.name
        } else {
            iconWalletImageView?.image = UIImage(named: "icon_not_selected")
            nameWalletLabel?.textColor = UIColor.lightGrayColor()
            nameWalletLabel?.text = "Choose Wallet"
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCategoryViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
            if let showCategories = segue.destinationViewController as? ShowCategoryViewController {
                showCategories.delegate = self
            }
        } else if segue.identifier == "NoteViewController" {
            if let noteViewController = segue.destinationViewController as? NoteViewController {
                noteViewController.delegate = self
                noteViewController.noteCurrent = noteCurrent
            }
        } else if segue.identifier == "DateViewController" {
            if let dateViewController = segue.destinationViewController as? DateViewController {
                dateViewController.delegate = self
                dateViewController.dateCurrent = dateCurrent
            }
        } else if segue.identifier == "ChooseLocationViewcontroller" {
            if let chooseLocationViewcontroller = segue.destinationViewController as? ChooseLocationViewcontroller {
                chooseLocationViewcontroller.delegate = self
            }
        }
    }
}

extension AddTransactionViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 6 {
            let storyBoard: UIStoryboard? = UIStoryboard(name: "Main", bundle: nil)
            if let chooseWalletVC = storyBoard?.instantiateViewControllerWithIdentifier("ChooseWalletTVC") as? ChooseWalletTableViewController {
//                chooseWalletVC.delegate = self
                self.navigationController?.pushViewController(chooseWalletVC, animated: true)
            }
        }
    }
}

//extension AddTransactionViewController: ChooseWalletDelegate {
//    func didChooseWallet(walletModel: WalletModel?) {
//        if let walletModel = walletModel {
//            wallet = walletModel
//            iconWalletImageView?.image = UIImage(named: walletModel.iconName)
//            nameWalletLabel?.textColor = UIColor.blackColor()
//            nameWalletLabel?.text = walletModel.name
//        }
//    }
//}

extension AddTransactionViewController: ChooseCategoryDelegate {
    func didChooseCategory(categoryModel: CategoryModel?) {
        if let categoryModel = categoryModel {
            category = categoryModel
            nameCategoryLabel?.textColor = UIColor.blackColor()
            iconCategoryImageView?.image = UIImage(named: categoryModel.iconCategory)
            nameCategoryLabel?.text = categoryModel.nameCategory
        }
    }
}

extension AddTransactionViewController: ChooseLocationDelegate {
    func didChooseLocation(namePlace: String) {
        location = namePlace
        locationLabel?.text = namePlace
    }
}

extension AddTransactionViewController: DataNoteDelegate {
    func didInputNote(string: String) {
        if string == "" {
            self.noteLabel?.textColor = UIColor.lightGrayColor()
            self.noteLabel?.text = "Note"
            self.noteCurrent = nil
        } else {
            self.noteCurrent = string
            self.noteLabel?.textColor = UIColor.blackColor()
            self.noteLabel?.text = string
        }
    }
}

extension AddTransactionViewController: ChooseDateDelegate {
    func didChooseDate(date: NSDate) {
        self.dateCurrent = date
        self.dateLabel?.text = date.getFormatDate()
    }
}
