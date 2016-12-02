//
//  NameCategoryCell.swift
//  MoneyLover
//
//  Created by Ngo Truong on 12/4/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class NameCategoryCell: ConfigCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCellWithContent(category: CategoryModel) {
        self.textLabel?.font = UIFont(name:"HelveticaNeue-Bold", size: 25)
        self.textLabel?.text = category.nameCategory
        self.imageView?.image = UIImage(named: category.iconCategory)
    }
}
