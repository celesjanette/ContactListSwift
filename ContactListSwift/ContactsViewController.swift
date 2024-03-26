//
//  ContactsViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/18/24.
//

import UIKit
import CoreData
class ContactsViewController: UIViewController, DateControllerDelegate {

    var currentContact: Contact?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldContact: UITextField!
        @IBOutlet weak var textFieldAddress: UITextField!
        @IBOutlet weak var textFieldCity: UITextField!
        @IBOutlet weak var textFieldState: UITextField!
        @IBOutlet weak var textFieldZipCode: UITextField!
        @IBOutlet weak var textFieldCellPhone: UITextField!
        @IBOutlet weak var textFieldHomePhone: UITextField!
        @IBOutlet weak var textFieldEmail: UITextField!
        @IBOutlet weak var sgmtEditMode: UISegmentedControl!
       
    @IBOutlet weak var btnChangeDate: UIButton!
    @IBOutlet weak var bdaylabel: UILabel!
    
    @IBOutlet weak var btnChange: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sgmtEditMode)
        //tap gesture recognizer to dismiss keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        //register the  keyboard notifs
        registerKeyboardNotifications()
        // adding listeners to my textfields
        changeEditMode(sgmtEditMode)
                let textFields: [UITextField] = [textFieldContact, textFieldAddress, textFieldCity, textFieldState, textFieldZipCode, textFieldCellPhone, textFieldHomePhone, textFieldEmail]
                for textField in textFields {
                    textField.addTarget(self, action: #selector(textFieldDidEndEditing(_:)), for: .editingDidEnd)
                }
            }
    @objc func textFieldDidEndEditing(_ textField: UITextField) -> Bool {
        guard textField.text != nil else { return false }
        
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        
        currentContact?.contactName = textFieldContact.text
        currentContact?.streetAddress = textFieldAddress.text
        currentContact?.city = textFieldCity.text
        currentContact?.state = textFieldState.text
        currentContact?.zipCode = textFieldZipCode.text
        currentContact?.cellNumber = textFieldCellPhone.text
        currentContact?.homeNumber = textFieldHomePhone.text
        currentContact?.email = textFieldEmail.text
        return true
    }
    @objc func saveContact() {
        appDelegate.saveContext()
        sgmtEditMode.selectedSegmentIndex = 0
        changeEditMode(sgmtEditMode)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueContactDate" {
            if let dateController = segue.destination as? DateViewController {
                dateController.delegate = self
            }
        }
            }
    func didSelectDate(_ date: Date) {
        if currentContact == nil {
            let context = appDelegate.persistentContainer.viewContext
            currentContact = Contact(context: context)
        }
        currentContact?.birthday = date
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        bdaylabel.text = formatter.string(from: date)
    }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            unregisterKeyboardNotifications()
        }
    

        func registerKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }

        func unregisterKeyboardNotifications() {
            NotificationCenter.default.removeObserver(self)
        }

        @objc func keyboardDidShow(notification: Notification) {
            guard let userInfo = notification.userInfo,
                  let keyboardInfo = userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
                return
            }
            let keyboardSize = keyboardInfo.cgRectValue.size
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = keyboardSize.height
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = contentInset
        }

        @objc func keyboardWillHide(notification: Notification) {
            var contentInset = self.scrollView.contentInset
            contentInset.bottom = 0
            self.scrollView.contentInset = contentInset
            self.scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        }

        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
    @IBAction func changeEditMode(_ sender: UISegmentedControl){
        let textFields: [UITextField] = [textFieldContact, textFieldAddress, textFieldEmail, textFieldCity, textFieldState, textFieldZipCode, textFieldCellPhone, textFieldHomePhone]
        if sender.selectedSegmentIndex == 0 {
            for textField in textFields {
                textField.isEnabled = false
                textField.borderStyle = .none
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem = nil
        } else if sender.selectedSegmentIndex == 1 {
            for textField in textFields {
                textField.isEnabled = true
                textField.borderStyle = .roundedRect
            }
            btnChange.isHidden = false
            navigationItem.rightBarButtonItem=UIBarButtonItem(barButtonSystemItem:.save, target: self, action: #selector(self.saveContact))
        }
    }


    
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


