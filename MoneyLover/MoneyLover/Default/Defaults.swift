//
//  Defaults.swift
//  E-LearningSystem
//
//  Created by Nguyen Van Dung on 11/16/16.
//  Copyright © 2016 Ngo Sy Truong. All rights reserved.
//

import Foundation

enum Defaults: String {
    case userID = "UserID"
    case currentWalletId = "CurrentWalletID"

    func set(value: AnyObject?) {
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: self.rawValue)
    }

    func get() -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(self.rawValue)
    }

    func getString() -> String? {
        return NSUserDefaults.standardUserDefaults().stringForKey(self.rawValue)
    }
}
