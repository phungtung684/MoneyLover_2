//
//  DetailCategoryViewController.swift
//  MoneyLover
//
//  Created by Ngo Truong on 12/4/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol DeleteCategoryDelegate: class {
    func didDeleteCategory(indexPath: NSIndexPath?)
}

protocol ReloadDataDelegate: class {
    func reloadTableWithOjec(category: CategoryModel, indexPath: NSIndexPath)
}

class DetailCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var category: CategoryModel?
    let listCell = ListCellViewDetailCategory()
    var categoryManager = CategoryManager()
    weak var delegate: DeleteCategoryDelegate?
    weak var reloadDelegate: ReloadDataDelegate?
    var indexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let category = category where category.typeCategory != CategoryModel.CategoryType.income {
            let buttonEdit = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(editAction))
            navigationItem.rightBarButtonItem = buttonEdit
        }
    }
    
    @objc private func editAction() {
        if let addCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddCategoryViewController") as? AddCategoryViewController {
            let navController = UINavigationController(rootViewController: addCategoryViewController)
            navController.navigationBar.translucent = false
            navController.navigationBar.barStyle = .BlackTranslucent
            navController.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
            navController.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
            addCategoryViewController.delegate = self
            addCategoryViewController.category = category
            self.presentViewController(navController, animated:true, completion: nil)
        }
    }
}

extension DetailCategoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listCell.listCellViewDetailCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewDetailCategory = listCell.listCellViewDetailCategory[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier(viewDetailCategory.cellIdentifier, forIndexPath: indexPath) as? ConfigCell {
            if let category = category {
                cell.configCellWithContent(category)
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension DetailCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let dataCell = listCell.listCellViewDetailCategory[indexPath.row]
        if let category = category {
            if dataCell.cellIdentifier == "deleteCell" && category.typeCategory == CategoryModel.CategoryType.income {
                return 0.0
            }
        }
        return dataCell.heighForCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let viewDetailCategory = listCell.listCellViewDetailCategory[indexPath.row]
        if viewDetailCategory.cellIdentifier == "deleteCell" {
            if let idCategory = category?.idCategory {
                if categoryManager.deleteCategory(idCategory) {
                    self.delegate?.didDeleteCategory(self.indexPath)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
}

extension DetailCategoryViewController: SaveCategoryDelegate {
    func didSaveCategory(category: CategoryModel) {
        self.reloadDelegate?.reloadTableWithOjec(category, indexPath: indexPath ?? NSIndexPath())
        self.category = category
        self.tableView?.reloadData()
    }
}
