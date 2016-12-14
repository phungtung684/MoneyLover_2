//
//  ListEditViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/2/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol ReloadShowCategoryDelegate: class {
    func reloadTable()
}
class ListEditCategoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var sectionData = [Section]()
    let cellIdentifier = "Cell"
    var categoryManager = CategoryManager()
    weak var delegate: ReloadShowCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("CategoryTitle", comment: "")
        tableView?.delegate = self
        tableView?.dataSource = self
        let section = SectionsData()
        self.sectionData.appendContentsOf(section.getSectionsFromData(self.categoryManager.getAllCategory()))
        self.addWalletBarButtonItem("icon_94")
    }
    
    private func addWalletBarButtonItem(iconName: String) {
        let button = UIButton()
        button.setImage(UIImage(named: iconName), forState: .Normal)
        button.addTarget(self, action: #selector(walletButtonAction), forControlEvents: .TouchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.round(15, borderWith: 1, borderColor: UIColor.blackColor().CGColor)
        button.layer.masksToBounds = true
        let walletButton = UIBarButtonItem(customView: button)
        let buttonAdd = UIBarButtonItem(title: "Thêm", style: .Plain, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItems = [buttonAdd, walletButton]
    }
    
    @objc func walletButtonAction() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let selectWalletTableController = storyboard.instantiateViewControllerWithIdentifier("SelectWalletTableController") as? SelectWalletTableViewController {
            selectWalletTableController.changeCurrentWalletDelegate = self
            let navigationController = UINavigationController(rootViewController: selectWalletTableController)
            navigationController.navigationBar.translucent = false
            navigationController.navigationBar.barStyle = .BlackTranslucent
            navigationController.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
            navigationController.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
            self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc private func addAction() {
        if let addCategoryViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddCategoryViewController") as? AddCategoryViewController {
            let navigationController = UINavigationController(rootViewController: addCategoryViewController)
            navigationController.navigationBar.translucent = false
            navigationController.navigationBar.barStyle = .BlackTranslucent
            navigationController.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
            navigationController.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
            self.presentViewController(navigationController, animated:true, completion: nil)
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
            detailCategoryViewController.reloadDelegate = self
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

extension ListEditCategoryViewController: ReloadDataDelegate {
    func reloadTableWithOjec(category: CategoryModel, indexPath: NSIndexPath) {
        self.delegate?.reloadTable()
        let car =  sectionData[indexPath.section].listCategory[indexPath.row]
        car.nameCategory = category.nameCategory
        car.iconCategory = category.iconCategory
        tableView?.reloadSections(NSIndexSet(index: indexPath.section), withRowAnimation: .None)
    }
    
}

extension ListEditCategoryViewController: ChangeCurrentWalletDelegate {
    func changeCurrentWallet(walletModel: WalletModel) {
        Defaults.currentWalletId.set(walletModel.idWallet)
        self.addWalletBarButtonItem(walletModel.iconName)
    }
}
