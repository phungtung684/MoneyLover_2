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
    
    func checkUserExisted(email: String) -> Bool {
        let listUser = dataStored.fetchRecordsForEntity("User", inManagedObjectContext: managedObjectContext)
        for users in listUser {
            if let user = users as? User {
                if user.email == email {
                    return true
                }
            }
        }
        return false
    }
    
    func addUser(email: String, password: String) -> Bool {
        if let user = dataStored.createRecordForEntity("User", inManagedObjectContext: managedObjectContext) as? User {
            user.email = email
            user.password = password
            do {
                try managedObjectContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
    
    func addUserFromSocial(email: String) -> Bool {
        if let user = dataStored.createRecordForEntity("User", inManagedObjectContext: managedObjectContext) as? User {
            user.email = email
            do {
                try managedObjectContext.save()
                return true
            } catch {
                return false
            }
        }
        return false
    }
}
