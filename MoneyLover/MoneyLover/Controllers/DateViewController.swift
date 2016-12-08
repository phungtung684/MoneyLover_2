//
//  DateViewController.swift
//  MoneyLover
//
//  Created by Ngo Sy Truong on 12/8/16.
//  Copyright © 2016 Phùng Tùng. All rights reserved.
//

import UIKit

protocol ChooseDateDelegate: class {
    func didChooseDate(date: NSDate)
}

class DateViewController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    weak var delegate: ChooseDateDelegate?
    var dateCurrent: NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker?.datePickerMode = UIDatePickerMode.Date
        if let dateCurrent = dateCurrent {
            datePicker?.date = dateCurrent
        }
    }
    
    @IBAction func chooseDate(sender: AnyObject) {
        if let sender = sender as? UIDatePicker {
            self.delegate?.didChooseDate(sender.date)
        }
    }
}
