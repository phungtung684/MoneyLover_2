//
//  TypeCategoryCell.swift
//  MoneyLover
//
//  Created by Ngo Truong on 12/4/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class TypeCategoryCell: ConfigCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func configCellWithContent(category: CategoryModel) {
        self.textLabel?.text = category.getTypeString()
        self.imageView?.image = UIImage(named: "ic_income_expense")
    }
}
