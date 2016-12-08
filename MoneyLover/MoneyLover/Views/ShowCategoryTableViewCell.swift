//
//  ShowCategoryTableViewCell.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/29/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class ShowCategoryTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCellWithContent(category: CategoryModel) {
        self.textLabel?.text = category.nameCategory
        self.imageView?.image = UIImage(named: category.iconCategory)
    }
}
