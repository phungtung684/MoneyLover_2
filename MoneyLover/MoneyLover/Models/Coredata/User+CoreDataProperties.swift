//
//  User+CoreDataProperties.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/14/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import Foundation
import CoreData


extension User {

    @NSManaged var email: String?
    @NSManaged var fullname: String?
    @NSManaged var idUser: NSNumber
    @NSManaged var password: String?
    @NSManaged var currentWallet: String?
    @NSManaged var wallet: NSSet?
}
