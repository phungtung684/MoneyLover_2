//
//  WalletManager.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/5/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class WalletManager {
    
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    var dataStored = DataStored()
    
    func checkWalletNameExits(name: String) -> Bool {
        let listWalletName = dataStored.fetchAttributePredicate("Wallet", attribute: "name", stringPredicate: name, inManagedObjectContext: managedObjectContext)
        if listWalletName.count == 0 {
            return false
        }
        return true
    }
    
    func checkEditWalletNameExits(name: String) -> Bool {
        let listWalletName = dataStored.fetchAttributePredicate("Wallet", attribute: "name", stringPredicate: name, inManagedObjectContext: managedObjectContext)
        if listWalletName.count <= 1 {
            return false
        }
        return true
    }
    
    func addWalletAvailable(walletModel: WalletModel) -> Wallet? {
        if let wallet = dataStored.createRecordForEntity("Wallet", inManagedObjectContext: managedObjectContext) as? Wallet {
            wallet.name = walletModel.name
            wallet.idWallet = walletModel.idWallet
            wallet.icon = walletModel.iconName
            wallet.amount = walletModel.amount
            do {
                try managedObjectContext.save()
                return wallet
            } catch let error {
                print(error)
            }
        }
        return nil
    }
    
    func addWallet(walletModel: WalletModel) -> Bool {
        if let wallet = dataStored.createRecordForEntity("Wallet", inManagedObjectContext: managedObjectContext) as? Wallet {
            wallet.name = walletModel.name
            wallet.idWallet = walletModel.idWallet
            wallet.icon = walletModel.iconName
            wallet.amount = walletModel.amount
            do {
                try managedObjectContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func editWallet(walletModel: WalletModel) -> Bool {
        let listWallet = dataStored.fetchAttributePredicate("Wallet", attribute: "idWallet", stringPredicate: walletModel.idWallet, inManagedObjectContext: managedObjectContext)
        if let wallet = listWallet.first as? Wallet {
            wallet.name = walletModel.name
            wallet.icon = walletModel.iconName
            wallet.amount = walletModel.amount
            do {
                try managedObjectContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func deleteWallet(idWallet: String) -> Bool {
        let listWallet = dataStored.fetchAttributePredicate("Wallet", attribute: "idWallet", stringPredicate: idWallet, inManagedObjectContext: managedObjectContext)
        if listWallet.count == 1 {
            if let wallet = listWallet.first as? Wallet {
                managedObjectContext.deleteObject(wallet)
                do {
                    try managedObjectContext.save()
                    return true
                } catch {
                    return false
                }
            }
        }
        return false
    }
    
    func showWalletDefault() -> WalletModel? {
        let listWallet = dataStored.fetchAttributePredicate("Wallet", attribute: "name", stringPredicate: "ATM", inManagedObjectContext: managedObjectContext)
        if listWallet.count == 1 {
            if let wallet = listWallet.first as? Wallet, let name = wallet.name, let id = wallet.idWallet, let icon = wallet.icon, let amount = wallet.amount {
                let walletModel = WalletModel(name: name, idWallet: id, iconName: icon, amount: amount.doubleValue)
                do {
                    try managedObjectContext.save()
                    return walletModel
                } catch {
                    return nil
                }
            }
        }
        return nil
    }
}
