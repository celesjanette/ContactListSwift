//
//  DateViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/26/24.
//

import UIKit
protocol DateControllerDelegate: AnyObject {
    func didSelectDate(_ date: Date)
}


class DateViewController: UIViewController {
    weak var delegate: DateControllerDelegate?

    @IBOutlet weak var dtpDate: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveDate))
                navigationItem.rightBarButtonItem = saveButton
                
                title = "Pick Birthdate"
   
    }
    @objc func saveDate() {
         
        delegate?.didSelectDate(dtpDate.date)
           
          
           navigationController?.popViewController(animated: true)
       }
   }



