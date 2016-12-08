//
//  WalletModel.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/5/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class WalletModel: NSObject {
    
    var name = ""
    var idWallet = ""
    var iconName = ""
    var amount = 0.0
    
    init(name: String, idWallet: String, iconName: String, amount: Double) {
        self.name = name
        self.idWallet = idWallet
        self.iconName = iconName
        self.amount = amount
    }
    
    convenience init(wallet: Wallet) {
        self.init(name: wallet.name ?? "icon_109", idWallet: wallet.idWallet ?? "", iconName: wallet.icon ?? "", amount: Double(wallet.amount ?? 1))
    }
}

class ListWalletAvalable {
    var listWallet = [WalletModel]()
    init() {
        listWallet.append(WalletModel(name: "ATM", idWallet: NSUUID().UUIDString, iconName: "icon_94", amount: 0.0))
        listWallet.append(WalletModel(name: "Tiền mặt", idWallet: NSUUID().UUIDString, iconName: "icon_117", amount: 0.0))
    }
}
