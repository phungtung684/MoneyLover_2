//
//  ListEditViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/2/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class ListEditCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sectionData = [Section]()
    let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Categories"
        tableView?.delegate = self
        tableView?.dataSource = self
        let buttonAdd = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem = buttonAdd
    }
    
    @objc private func addAction() {
        if let addCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddCategoryViewController") as? AddCategoryViewController {
            let navController = UINavigationController(rootViewController: addCategoryViewController)
            self.presentViewController(navController, animated:true, completion: nil)
        }
    }
}

extension ListEditCategoryViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionData[section].title
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionData[section].listCategory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as? ShowCategoryTableViewCell {
            let category = sectionData[indexPath.section].listCategory[indexPath.row]
            cell.configCellWithContent(category)
            return cell
        }
        return UITableViewCell()
    }
}

extension ListEditCategoryViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let detailCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DetailCategoryViewController") as? DetailCategoryViewController {
            let category = sectionData[indexPath.section].listCategory[indexPath.row]
            detailCategoryViewController.category = category
            detailCategoryViewController.delegate = self
            detailCategoryViewController.indexPath = indexPath
            self.navigationController?.pushViewController(detailCategoryViewController, animated: true)
        }
    }
}

extension ListEditCategoryViewController: DeleteCategoryDelegate {
    func didDeleteCategory(indexPath: NSIndexPath?) {
        if let indexPath = indexPath {
            var listCategory = sectionData[indexPath.section].listCategory
            listCategory.removeAtIndex(indexPath.row)
            sectionData[indexPath.section].listCategory = listCategory
            tableView?.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
        }
    }
}
