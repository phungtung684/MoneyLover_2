//
//  CategoryModel.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/2/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class CategoryModel: NSObject {
    
    enum CategoryType: Int {
        case income = 2
        case expense = 1
        case deptLoan = 0
    }
    var nameCategory = ""
    var typeCategory: CategoryType
    var iconCategory = ""
    var idCategory = 0
    
    init(nameCategory: String, typeCategory: CategoryType, iconCategory: String, idCategory: Int) {
        self.nameCategory = nameCategory
        self.iconCategory = iconCategory
        self.idCategory = idCategory
        self.typeCategory = typeCategory
    }
    
    
    func getTypeString() -> String {
        switch typeCategory {
        case .income:
            if nameCategory == "Repayment" || nameCategory == "Loan" {
                return "Expense"
            } else {
                return "Income"
            }
        case .expense:
            return "Expense"
        default:
            return "Income"
        }
    }
    
    func getTypeInt() -> Int {
        switch typeCategory {
        case .income:
            if nameCategory == "Repayment" || nameCategory == "Loan" {
                return 1
            } else {
                return 0
            }
        case .expense:
            return 1
        default:
            return 0
        }
    }
}

class ListCategoryAvailable {
    
    var listCategory = [CategoryModel]()
    
    init() {
        listCategory.append(CategoryModel(nameCategory: "Bill & Utilities", typeCategory: .expense, iconCategory: "icon_4", idCategory: 1))
        listCategory.append(CategoryModel(nameCategory: "Phone ", typeCategory: .expense, iconCategory: "icon_9", idCategory: 2))
        listCategory.append(CategoryModel(nameCategory: "Water", typeCategory: .expense, iconCategory: "icon_12", idCategory: 3))
        listCategory.append(CategoryModel(nameCategory: "Electricity", typeCategory: .expense, iconCategory: "icon_26", idCategory: 4))
        listCategory.append(CategoryModel(nameCategory: "Gas", typeCategory: .expense, iconCategory: "icon_19", idCategory: 5))
        listCategory.append(CategoryModel(nameCategory: "Television", typeCategory: .expense, iconCategory: "icon_20", idCategory: 6))
        listCategory.append(CategoryModel(nameCategory: "Internet", typeCategory: .expense, iconCategory: "icon_21", idCategory: 7))
        listCategory.append(CategoryModel(nameCategory: "Cafe", typeCategory: .expense, iconCategory: "icon_15", idCategory: 8))
        listCategory.append(CategoryModel(nameCategory: "Shopping", typeCategory: .expense, iconCategory: "icon_30", idCategory: 9))
        listCategory.append(CategoryModel(nameCategory: "Friends & Lover", typeCategory: .expense, iconCategory: "ic_category_friendnlover", idCategory: 10))
        listCategory.append(CategoryModel(nameCategory: "Loan", typeCategory: .deptLoan, iconCategory: "ic_category_loan", idCategory: 11))
        listCategory.append(CategoryModel(nameCategory: "Repayment", typeCategory: .deptLoan, iconCategory: "icon_31", idCategory: 12))
        listCategory.append(CategoryModel(nameCategory: "Debt", typeCategory: .deptLoan, iconCategory: "ic_category_debt", idCategory: 13))
        listCategory.append(CategoryModel(nameCategory: "Debt Colection", typeCategory: .deptLoan, iconCategory: "icon_33", idCategory: 14))
        listCategory.append(CategoryModel(nameCategory: "Award", typeCategory: .income, iconCategory: "ic_category_award", idCategory: 15))
        listCategory.append(CategoryModel(nameCategory: "Interest Money", typeCategory: .income, iconCategory: "ic_category_interestmoney", idCategory: 16))
        listCategory.append(CategoryModel(nameCategory: "Salary", typeCategory: .income, iconCategory: "icon_36", idCategory: 17))
        listCategory.append(CategoryModel(nameCategory: "Gifts", typeCategory: .income, iconCategory: "icon_66", idCategory: 18))
    }
}
