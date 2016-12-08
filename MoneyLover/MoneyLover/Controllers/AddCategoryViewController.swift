//
//  AddCategoryViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/29/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol SaveCategoryDelegate: class {
    func didSaveCategory(categoryModel: CategoryModel)
}

class AddCategoryViewController: UITableViewController {
    
    @IBOutlet weak var typeCategorySegmentedControl: UISegmentedControl!
    @IBOutlet weak var inputNameTextField: UITextField!
    @IBOutlet weak var iconCategoryImageView: UIImageView!
    var nameIcon = ""
    var category: CategoryModel?
    var categoryManager = CategoryManager()
    weak var delegate: SaveCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = category {
            self.title = "Edit Category"
            inputNameTextField?.text = category.nameCategory
            typeCategorySegmentedControl?.selectedSegmentIndex = category.getTypeInt()
            iconCategoryImageView?.image = UIImage(named: category.iconCategory)
        } else {
            self.title = "New Category"
        }
        let buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(saveAction))
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = buttonSave
        navigationItem.leftBarButtonItem = buttonCancel
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped))
        iconCategoryImageView?.userInteractionEnabled = true
        iconCategoryImageView?.addGestureRecognizer(tapGestureRecognizer)
        self.navigationController?.navigationBar.tintColor = UIColor.greenColor()
    }
    
    func imageTapped() {
        if let showIconViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ShowIconViewController") as? ShowIconViewController {
            showIconViewController.delegate = self
            self.navigationController?.pushViewController(showIconViewController, animated: true)
        }
    }
    
    @objc private func saveAction() {
        var typeCategories = CategoryModel.CategoryType.deptLoan
        if let category = category {
            if let nameCategory = self.inputNameTextField?.text, let typeCategory = self.typeCategorySegmentedControl?.selectedSegmentIndex {
                if nameIcon == "" {
                    nameIcon = category.iconCategory
                }
                if typeCategory == 0 {
                    typeCategories = CategoryModel.CategoryType.income
                } else {
                    typeCategories = CategoryModel.CategoryType.expense
                }
                let category = CategoryModel(nameCategory: nameCategory, typeCategory: typeCategories, iconCategory: nameIcon, idCategory: category.idCategory)
                if categoryManager.updateCategory(category) {
                    self.delegate?.didSaveCategory(category)
                    self.dismissViewControllerAnimated(true, completion: nil)
                } else {
                    presentAlertWithTitle("Error", message: "Can't update category.")
                }
            }
        } else {
            if let nameCategory = self.inputNameTextField?.text, let typeCategory = self.typeCategorySegmentedControl?.selectedSegmentIndex {
                if typeCategory == 0 {
                    typeCategories = CategoryModel.CategoryType.income
                } else {
                    typeCategories = CategoryModel.CategoryType.expense
                }
                let category = CategoryModel(nameCategory: nameCategory, typeCategory: typeCategories, iconCategory: nameIcon, idCategory: 0)
                if categoryManager.checkCategoryExisted(nameCategory) {
                    presentAlertWithTitle("Error", message: "Category was existed")
                } else {
                    if let categoryModel = categoryManager.addCategory(category) {
                        self.delegate?.didSaveCategory(categoryModel)
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } else {
                        presentAlertWithTitle("Error", message: "Can't add category.")
                    }
                }
            }
        }
    }
    
    @objc private func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AddCategoryViewController: ChooseIconDelegate {
    func didChooseIcon(nameIcon: String) {
        self.nameIcon = nameIcon
        self.iconCategoryImageView?.image = UIImage(named: nameIcon)
    }
}
