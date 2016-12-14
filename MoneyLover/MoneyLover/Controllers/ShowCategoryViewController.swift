//
//  ShowCategoryViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/29/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol ChooseCategoryDelegate: class {
    func didChooseCategory(categoryModel: CategoryModel?)
}

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
    weak var delegate: ChooseCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView?.dataSource = self
        tableView?.delegate = self
        self.title = NSLocalizedString("ChooseCategoryTitle", comment: "")
        chooseTypeSegmentedControl?.selectedSegmentIndex = 1
        rightbutton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: #selector(editAction))
        navigationItem.rightBarButtonItem = rightbutton
        dictCategory = self.categoryManager.getAllCategory()
    }
    
    @IBAction func chooseTypeCategory(sender: AnyObject) {
        self.tableView?.reloadData()
    }
    
    @objc private func editAction() {
        if let listEditCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ListEditCategoryViewController") as? ListEditCategoryViewController {
            listEditCategoryViewController.delegate = self
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
        self.delegate?.didChooseCategory(dataCategory[indexPath.row])
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension ShowCategoryViewController: ReloadShowCategoryDelegate {
    func reloadTable() {
        dictCategory = self.categoryManager.getAllCategory()
        self.tableView.reloadData()
    }
}
