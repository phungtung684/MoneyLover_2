//
//  TransactionsViewController.swift
//  MoneyLover
//
//  Created by Phung Tung on 11/24/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    var tableView1: UITableView!
    var tableView2: UITableView!
    var tableView3: UITableView!
    var scrollView: UIScrollView!
    var topView: UIView!
    var lastMonthButton: UIButton!
    var thisMonthButton: UIButton!
    var futureButton: UIButton!
    var scrollViewRect: CGRect!
    var str = "Tung"
    var prevIndex = 1
    var currIndex = 2
    var nextIndex = 3
    @IBOutlet weak var scrollViewContent: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        self.configScrollView()
        self.addTableToView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configScrollView() {
        self.scrollViewRect = CGRect(x: 0, y: self.view.bounds.size.height/12, width: self.view.bounds.size.width, height: (self.view.bounds.size.height * 11)/12)
        self.scrollView = UIScrollView(frame: scrollViewRect)
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSize(width: scrollViewRect.size.width * 3.0, height: scrollViewRect.size.height)
        scrollView.scrollRectToVisible(CGRect(x: scrollViewRect.size.width, y: 0, width: scrollViewRect.size.width, height: scrollViewRect.size.height), animated: false)
        self.scrollView.backgroundColor = UIColor(red: 241.0/255.0, green: 240.0/255.0, blue: 246.0/255, alpha: 1)
        self.view.addSubview(scrollView)
    }
    
    private func addTableToView() {
        // setup table 1
        let tableViewRect1 = CGRect(x: 0, y: 0, width: scrollViewRect.size.width, height: scrollViewRect.size.height)
        self.tableView1 = UITableView(frame: tableViewRect1)
        self.tableView1.dataSource = self
        self.tableView1.delegate = self
        tableView1?.registerNib(UINib(nibName: "OverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "OverViewCell")
        tableView1?.registerNib(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell")
        tableView1?.registerNib(UINib(nibName: "HeaderTransactionSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "TransactionHeader")
        self.scrollView.addSubview(tableView1)
        // setup table 2
        let tableViewRect2 = CGRect(x: scrollViewRect.size.width, y: 0, width: scrollViewRect.size.width, height: scrollViewRect.size.height)
        self.tableView2 = UITableView(frame: tableViewRect2)
        self.tableView2.dataSource = self
        self.tableView2.delegate = self
        tableView2?.registerNib(UINib(nibName: "OverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "OverViewCell2")
        tableView2?.registerNib(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell2")
        tableView2?.registerNib(UINib(nibName: "HeaderTransactionSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "TransactionHeader2")
        self.scrollView.addSubview(tableView2)
        // setup table 3
        let tableViewRect3 = CGRect(x: scrollViewRect.size.width * 2, y: 0, width: scrollViewRect.size.width, height: scrollViewRect.size.height)
        self.tableView3 = UITableView(frame: tableViewRect3)
        self.tableView3.dataSource = self
        self.tableView3.delegate = self
        tableView3?.registerNib(UINib(nibName: "OverViewTableViewCell", bundle: nil), forCellReuseIdentifier: "OverViewCell3")
        tableView3?.registerNib(UINib(nibName: "TransactionTableViewCell", bundle: nil), forCellReuseIdentifier: "TransactionCell3")
        tableView3?.registerNib(UINib(nibName: "HeaderTransactionSection", bundle: nil), forHeaderFooterViewReuseIdentifier: "TransactionHeader3")
        self.scrollView.addSubview(tableView3)
    }
    
    private func loadTableWithID(index: Int, onTableIndex: Int) {
        if index == 1 {
            str = "Table 1"
            tableView1.reloadData()
        } else if index == 2 {
            str = "Table 2"
            tableView2.reloadData()
        } else {
            str = "Table 3"
            tableView3.reloadData()
        }
    }
}

extension TransactionsViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        // keep track of the index that we are scrolling to so that we
        // know what data to load for each table.
        if scrollView.contentOffset.x > scrollView.frame.size.width {
            print("moving forward.")
            // moving forward. Load the current table data on the first page.
            self.loadTableWithID(currIndex, onTableIndex: 1)
            // Add one to the currentIndex or reset to 0 if we have reached the end.
            currIndex = (currIndex == 3) ? 0 : currIndex + 1
            self.loadTableWithID(currIndex, onTableIndex: 1)
            // Load content on the last table
            // or the first if we have reached the end.
            nextIndex = (currIndex == 3) ? 0 : currIndex + 1
            self.loadTableWithID(nextIndex, onTableIndex: 2)
        }
        if scrollView.contentOffset.x < scrollView.frame.size.width {
            print(" We are moving backward.")
            // moving backward. Load the current table data on the last page.
            self.loadTableWithID(currIndex, onTableIndex: 2)
            // Subtract one from the currentIndex or go to the end if we have reached the beginning.
            currIndex = (currIndex == 0) ? 3 : currIndex - 1
            self.loadTableWithID(currIndex, onTableIndex: 1)
            // Load content on the first page
            // or the last if we have reached the beginning.
            prevIndex = (currIndex == 0) ? 3 : currIndex - 1
            self.loadTableWithID(currIndex, onTableIndex: 0)
        }
        // Reset offset back to middle page
        scrollView.scrollRectToVisible(CGRect(x: scrollViewRect.size.width, y: 0, width: scrollViewRect.size.width, height: scrollViewRect.size.height), animated: false)
    }
}

extension TransactionsViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == tableView1 {
            if indexPath.section == 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("OverViewCell", forIndexPath: indexPath) as? OverViewTableViewCell {
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell", forIndexPath: indexPath) as? TransactionTableViewCell {
                    cell.moneyLabel.text = str
                    return cell
                }
            }
        } else if tableView == tableView2 {
            if indexPath.section == 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("OverViewCell2", forIndexPath: indexPath) as? OverViewTableViewCell {
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell2", forIndexPath: indexPath) as? TransactionTableViewCell {
                    cell.moneyLabel.text = str
                    return cell
                }
            }
        } else if tableView == tableView3 {
            if indexPath.section == 0 {
                if let cell = tableView.dequeueReusableCellWithIdentifier("OverViewCell3", forIndexPath: indexPath) as? OverViewTableViewCell {
                    return cell
                }
            } else {
                if let cell = tableView.dequeueReusableCellWithIdentifier("TransactionCell3", forIndexPath: indexPath) as? TransactionTableViewCell {
                    cell.moneyLabel.text = str
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 110
        }
        return 50
    }
}

extension TransactionsViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 40
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == tableView1 {
            if let headerSection = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TransactionHeader") as? HeaderTransactionSection {
                return headerSection
            }
        } else if tableView == tableView2 {
            if let headerSection = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TransactionHeader2") as? HeaderTransactionSection {
                return headerSection
            }
        } else if tableView == tableView2 {
            if let headerSection = tableView.dequeueReusableHeaderFooterViewWithIdentifier("TransactionHeader3") as? HeaderTransactionSection {
                return headerSection
            }
        }
        return UITableViewHeaderFooterView()
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
}

extension TransactionsViewController: UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if tabBarController.selectedIndex == 2 {
            let storyBoard: UIStoryboard? = UIStoryboard(name: "AddTransaction", bundle: nil)
            if let addTransaction = storyBoard?.instantiateViewControllerWithIdentifier("AddTransactionViewController") as? AddTransactionViewController {
                let navigationController = UINavigationController(rootViewController: addTransaction)
                navigationController.navigationBar.translucent = false
                navigationController.navigationBar.barStyle = .BlackTranslucent
                navigationController.navigationBar.barTintColor = UIColor.whiteColor()
                navigationController.navigationBar.tintColor = UIColor(red: 4.0 / 255, green: 76.0 / 255, blue: 49.0 / 255, alpha: 1)
                navigationController.navigationBar.barTintColor = UIColor(red: 39.0 / 255, green: 186.0 / 255, blue: 85.0 / 255, alpha: 1)
                self.navigationController?.presentViewController(navigationController, animated: true, completion: nil)
            }
        }
        
    }
}
