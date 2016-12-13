//
//  SelecWalletTableViewCell.swift
//  MoneyLover
//
//  Created by Phùng Tùng on 12/14/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class SelecWalletTableViewCell: UITableViewCell {

    @IBOutlet weak var nameWalletLabel: UILabel!
    @IBOutlet weak var amountWalletLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
