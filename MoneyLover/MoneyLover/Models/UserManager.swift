//
//  UserManager.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/24/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    var dataStored = DataStored()
    var listWalletAvailable = ListWalletAvalable()
    var walletManager = WalletManager()
    var categoryManager = CategoryManager()
    
    func checkUserExisted(email: String) -> Bool {
        Defaults.userID.set(email)
        let listUser = dataStored.fetchAttributePredicate("User", attribute: "email", stringPredicate: email, inManagedObjectContext: managedObjectContext)
        if listUser.count == 0 {
            self.removeUserIDDefaults()
            return false
        }
        self.removeUserIDDefaults()
        return true
    }
    
    func checkUserLogin(email: String, password: String) -> Bool {
        Defaults.userID.set(email)
        let users = dataStored.fetchAttributePredicate("User", attribute: "email", stringPredicate: email, inManagedObjectContext: managedObjectContext)
        if users.count == 1 {
            guard let user = users.first as? User else {
                self.removeUserIDDefaults()
                return false
            }
            if user.password == password {
                Defaults.currentWalletId.set(user.currentWallet)
                return true
            }
        }
        self.removeUserIDDefaults()
        return false
    }
    
    func addUser(email: String, password: String) -> Bool {
        Defaults.userID.set(email)
        if let user = dataStored.createRecordForEntity("User", inManagedObjectContext: managedObjectContext) as? User {
            user.email = email
            user.password = password
            user.currentWallet = "215C0B02-4270-43F6-A273-B743869CD2AD"
            do {
                self.walletManager.addWalletDefault()
                self.categoryManager.addCategoryDefault()
                try managedObjectContext.save()
                self.removeUserIDDefaults()
                return true
            } catch {
                return false
            }
        }
        self.removeUserIDDefaults()
        return false
    }
    
    func addUserFromSocial(email: String) -> Bool {
        Defaults.userID.set(email)
        if let user = dataStored.createRecordForEntity("User", inManagedObjectContext: managedObjectContext) as? User {
            user.email = email
            user.currentWallet = "215C0B02-4270-43F6-A273-B743869CD2AD"
            Defaults.currentWalletId.set("215C0B02-4270-43F6-A273-B743869CD2AD")
            do {
                self.walletManager.addWalletDefault()
                self.categoryManager.addCategoryDefault()
                try managedObjectContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func removeUserIDDefaults() {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("UserID")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func changePassword(oldPassword: String, newPassword: String) -> Bool {
        let users = dataStored.fetchAttributePredicate("User", attribute: "email", stringPredicate: Defaults.userID.getString() ?? "", inManagedObjectContext: managedObjectContext)
        if users.count == 1 {
            if let user = users.first as? User {
                if user.password == oldPassword {
                    user.password = newPassword
                    do {
                        try managedObjectContext.save()
                        return true
                    } catch {
                        return false
                    }
                }
            }
        }
        return false
    }
}
