//
//  AddWalletTableViewController.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/5/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol AddWalletTableViewControllerDelegate: class {
    func reloadData()
}

class AddWalletTableViewController: UITableViewController {
    
    @IBOutlet weak var nameWalletTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var iconImageView: UIImageView!
    var nameIcon = "icon_109"
    var walletManager = WalletManager()
    weak var delegate: AddWalletTableViewControllerDelegate?
    var wallet: Wallet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        iconImageView?.userInteractionEnabled = true
        iconImageView?.addGestureRecognizer(tapGestureRecognizer)
        if wallet != nil {
            nameWalletTextField?.text = wallet?.name
            iconImageView.image = UIImage(named: wallet?.icon ?? "icon_109")
            moneyTextField.text = "\(wallet?.amount ?? 0.0)"
        }
    }

    @objc private func imageTapped() {
        let storyboard = UIStoryboard(name: "AddTransaction", bundle: nil)
        if let chooseIcon = storyboard.instantiateViewControllerWithIdentifier("ShowIconViewController") as? ShowIconViewController {
            chooseIcon.delegate = self
            self.navigationController?.pushViewController(chooseIcon, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancelAction(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                if wallet == nil {
                    if walletManager.checkWalletNameExits(nameWalletTextField.text ?? "") {
                        self.presentAlertWithTitle(NSLocalizedString("LogoutConfirmTitle", comment: ""), message: NSLocalizedString("MessageAlertNameWalletExits", comment: ""))
                    } else {
                        if walletManager.addWallet(WalletModel(name: nameWalletTextField.text ?? "", iconName: nameIcon, amount: Double(moneyTextField.text ?? "") ?? 0.0)) {
                            self.delegate?.reloadData()
                            self.navigationController?.popViewControllerAnimated(true)
                        } else {
                            self.presentAlertWithTitle(NSLocalizedString("ErrorAlertTitle", comment: ""), message: NSLocalizedString("MessageAlertErrorAddWallet", comment: ""))
                        }
                    }
                } else {
                    if walletManager.checkEditWalletNameExits(nameWalletTextField.text ?? "") {
                        self.presentAlertWithTitle(NSLocalizedString("LogoutConfirmTitle", comment: ""), message: NSLocalizedString("MessageAlertNameWalletExits", comment: ""))
                    } else {
                        if  walletManager.editWallet(wallet?.idWallet ?? "", walletModel: WalletModel(name: nameWalletTextField.text ?? "", iconName: nameIcon, amount: Double(moneyTextField.text ?? "") ?? 0.0)) {
                            if let ChooseWalletTVC = self.storyboard?.instantiateViewControllerWithIdentifier("ChooseWalletTVC") as? ChooseWalletTableViewController {
                                self.navigationController?.pushViewController(ChooseWalletTVC, animated: true)
                            }
                            
                        } else {
                            self.presentAlertWithTitle(NSLocalizedString("ErrorAlertTitle", comment: ""), message: NSLocalizedString("MessageAlertErrorAddWallet", comment: ""))
                        }
                    }
                }
            }
        }
    }
}

extension AddWalletTableViewController: ChooseIconDelegate {
    func didChooseIcon(nameIcon: String) {
        self.nameIcon = nameIcon
        self.iconImageView?.image = UIImage(named: nameIcon)
    }
}
