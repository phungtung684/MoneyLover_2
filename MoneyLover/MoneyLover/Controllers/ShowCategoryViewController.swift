//
//  ShowCategoryViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/29/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class ShowCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chooseTypeSegmentedControl: UISegmentedControl!
    var dataStored = DataStored()
    lazy var managedObjectContext = CoreDataManager().managedObjectContext
    var dataCategory = [CategoryModel]()
    var rightbutton = UIBarButtonItem()
    let cellIdentifier = "Cell"
    var categoryManager = CategoryManager()
    var listCategoryAvailable = ListCategoryAvailable()
    var dictCategory = [0: [CategoryModel](), 1: [CategoryModel](), 2: [CategoryModel]()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.title = "Select Category"
        chooseTypeSegmentedControl?.selectedSegmentIndex = 1
        rightbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(editAction))
        navigationItem.rightBarButtonItem = rightbutton
        let listCategory = dataStored.fetchRecordsForEntity("Category", inManagedObjectContext: managedObjectContext)
        if listCategory.count == 0 {
            for category in listCategoryAvailable.listCategory {
                if let category = categoryManager.addCategoryAvailale(category) {
                    if let typeCategory = category.type, let nameCategory = category.name, let iconCategory = category.icon, let idCategory = category.idCategory {
                        if typeCategory == 1 {
                            dictCategory[1]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.expense, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        } else if typeCategory == 0 {
                            dictCategory[0]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.deptLoan, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        } else {
                            dictCategory[2]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.income, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        }
                    }
                }
            }
        } else {
            if let listCategory = listCategory as? [Category] {
                for category in listCategory {
                    if let typeCategory = category.type, let nameCategory = category.name, let iconCategory = category.icon, let idCategory = category.idCategory {
                        if typeCategory == 1 {
                            dictCategory[1]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.expense, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        } else if typeCategory == 0 {
                            dictCategory[0]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.deptLoan, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        } else {
                            dictCategory[2]?.append(CategoryModel(nameCategory: nameCategory, typeCategory: CategoryModel.CategoryType.income, iconCategory: iconCategory, idCategory: idCategory.integerValue))
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func chooseTypeCategory(sender: AnyObject) {
        self.tableView?.reloadData()
    }
    
    @objc private func editAction() {
        if let listEditCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ListEditCategoryViewController") as? ListEditCategoryViewController {
            let section = SectionsData()
            listEditCategoryViewController.sectionData.appendContentsOf(section.getSectionsFromData(dictCategory))
            self.navigationController?.pushViewController(listEditCategoryViewController, animated: true)
        }
    }
}

extension ShowCategoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let typeCategory = chooseTypeSegmentedControl?.selectedSegmentIndex {
            if typeCategory == 0 {
                if let listIncome = dictCategory[2] {
                    dataCategory = listIncome
                }
            } else if chooseTypeSegmentedControl?.selectedSegmentIndex == 1 {
                if let listExpense = dictCategory[1] {
                    dataCategory = listExpense
                }
            } else {
                if let listDeptLoan = dictCategory[0] {
                    dataCategory = listDeptLoan
                }
            }
        }
        return dataCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ShowCategoryTableViewCell {
            let category = dataCategory[indexPath.row]
            cell.configCellWithContent(category)
            return cell
        }
        return UITableViewCell()
    }
}

extension ShowCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

extension ShowCategoryViewController: SaveCategoryDelegate {
    func didSaveCategory(category: CategoryModel) {
        self.tableView?.reloadData()
    }
}
