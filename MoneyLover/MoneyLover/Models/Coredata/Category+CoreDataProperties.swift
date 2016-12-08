//
//  Category+CoreDataProperties.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/23/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import Foundation
import CoreData

extension Category {
    
    @NSManaged var idCategory: NSNumber?
    @NSManaged var name: String?
    @NSManaged var type: NSNumber?
    @NSManaged var icon: String?
    @NSManaged var transactionWithCategory: NSSet?
}
