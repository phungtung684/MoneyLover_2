//
//  AddTransactionViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 11/28/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

class AddTransactionViewController: UITableViewController {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    var noteCurrent: String?
    var dateCurrent = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Add Transaction"
        let buttonSave = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Save, target: self, action: #selector(saveAction))
        let buttonCancel = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: #selector(cancelAction))
        navigationItem.rightBarButtonItem = buttonSave
        navigationItem.leftBarButtonItem = buttonCancel
        self.navigationController?.navigationBar.tintColor = UIColor.greenColor()
        self.dateLabel?.text = dateCurrent.getFormatDate()
    }
    
    @objc private func saveAction() {
    }
    
    @objc private func cancelAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowCategoryViewController" {
            let backItem = UIBarButtonItem()
            backItem.title = "Back"
            navigationItem.backBarButtonItem = backItem
        } else if segue.identifier == "NoteViewController" {
            if let noteViewController = segue.destinationViewController as? NoteViewController {
                noteViewController.delegate = self
                noteViewController.noteCurrent = noteCurrent
            }
        } else if segue.identifier == "DateViewController" {
            if let dateViewController = segue.destinationViewController as? DateViewController {
                dateViewController.delegate = self
                dateViewController.dateCurrent = dateCurrent
            }
        } else if segue.identifier == "ChooseLocationViewcontroller" {
            if let chooseLocationViewcontroller = segue.destinationViewController as? ChooseLocationViewcontroller {
                chooseLocationViewcontroller.delegate = self
            }
        }
    }
}

extension AddTransactionViewController: ChooseLocationDelegate {
    func didChooseLocation(namePlace: String) {
        locationLabel?.text = namePlace
        print(namePlace)
    }
}

extension AddTransactionViewController: DataNoteDelegate {
    func didInputNote(string: String) {
        if string == "" {
            self.noteLabel?.textColor = UIColor.lightGrayColor()
            self.noteLabel?.text = "Note"
            self.noteCurrent = nil
        } else {
            self.noteCurrent = string
            self.noteLabel?.textColor = UIColor.blackColor()
            self.noteLabel?.text = string
        }
    }
}

extension AddTransactionViewController: ChooseDateDelegate {
    func didChooseDate(date: NSDate) {
        self.dateCurrent = date
        self.dateLabel?.text = date.getFormatDate()
    }
}
