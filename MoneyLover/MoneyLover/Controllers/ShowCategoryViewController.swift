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
    var dataCategory = [Category]()
    var rightbutton = UIBarButtonItem()
    let cellIdentifier = "Cell"
    var categoryManager = CategoryManager()
    var listCategoryAvailable = ListCategoryAvailable()
    var dictCategory = [0: [Category](), 1: [Category](), 2: [Category]()]
    
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
                if let category = categoryManager.addCategoryAvailale(category), let typeCategory = category.type {
                    if typeCategory == 1 {
                        dictCategory[1]?.append(category)
                    } else if typeCategory == 0 {
                        dictCategory[0]?.append(category)
                    } else {
                        dictCategory[2]?.append(category)
                    }
                }
            }
        } else {
            for categories in listCategory {
                if let category = categories as? Category, let typeCategory = category.type {
                    if typeCategory == 1 {
                        dictCategory[1]?.append(category)
                    } else if typeCategory == 0 {
                        dictCategory[0]?.append(category)
                    } else {
                        dictCategory[2]?.append(category)
                    }
                }
            }
        }
    }
    
    @IBAction func chooseTypeCategory(sender: AnyObject) {
        self.tableView?.reloadData()
    }
    
    @objc private func editAction() {
        if let listEdit = self.storyboard?.instantiateViewControllerWithIdentifier("ListEditCategoryViewController") as? ListEditCategoryViewController {
            let section = SectionsData()
            listEdit.sectionData.appendContentsOf(section.getSectionsFromData(dictCategory))
            self.navigationController?.pushViewController(listEdit, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ShowCategoryViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let typeCategory = chooseTypeSegmentedControl?.selectedSegmentIndex {
            if typeCategory == 0 {
                if let listDeptLoan = dictCategory[0] {
                    dataCategory = listDeptLoan
                }
            } else if chooseTypeSegmentedControl?.selectedSegmentIndex == 1 {
                if let listExpense = dictCategory[1] {
                    dataCategory = listExpense
                }
            } else {
                if let listIncome = dictCategory[2] {
                    dataCategory = listIncome
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
