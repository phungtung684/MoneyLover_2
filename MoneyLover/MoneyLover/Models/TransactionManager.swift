//
//  TransactionManager.swift
//  MoneyLover
//
//  Created by Ngo Truong on 12/6/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class TransactionManager: NSObject {
    
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    var dataStored = DataStored()
    
    func addTransaction(transactionModel: TransactionModel) -> Bool {
        var id = 0
        let listTransaction = dataStored.fetchRecordsForEntity("Transaction", inManagedObjectContext: managedObjectContext)
        if let lastTransaction = listTransaction.last as? Transaction {
            if let idTransaction = lastTransaction.idTransaction as? Int {
                id = idTransaction + 1
                transactionModel.idTransaction = id
            }
        }
        if let transaction = dataStored.createRecordForEntity("Transaction", inManagedObjectContext: managedObjectContext) as? Transaction {
            transaction.amount = transactionModel.amount
            transaction.note = transactionModel.note
            transaction.date = transactionModel.date
            transaction.location = transactionModel.location
            transaction.idTransaction = id
            let category = dataStored.fetchAttributeIDPredicate("Category", attribute: "idCategory", predicate: transactionModel.categoryWithTransaction?.idCategory ?? 1, inManagedObjectContext: managedObjectContext)
            let wallet = dataStored.fetchAttributePredicate("Wallet", attribute: "idWallet", stringPredicate: transactionModel.walletWithTransaction?.idWallet ?? "", inManagedObjectContext: managedObjectContext)
            if let category = category.first as? Category, let wallet = wallet.first as? Wallet {
                transaction.categoryWithTransaction = category
                transaction.walletWithTransaction = wallet
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
}
