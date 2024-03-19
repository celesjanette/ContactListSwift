//
//  ContactsViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/18/24.
//

import UIKit

class ContactsViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textFieldContact: UITextField!
        @IBOutlet weak var textFieldAddress: UITextField!
        @IBOutlet weak var textFieldCity: UITextField!
        @IBOutlet weak var textFieldState: UITextField!
        @IBOutlet weak var textFieldZipCode: UITextField!
        @IBOutlet weak var textFieldCellPhone: UITextField!
        @IBOutlet weak var textFieldHomePhone: UITextField!
        @IBOutlet weak var textFieldEmail: UITextField!
        @IBOutlet weak var textFieldBirthday: UITextField!
    override func viewDidLoad() {
            super.viewDidLoad()
            
            // Add tap gesture recognizer to dismiss keyboard
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
            
            // Register keyboard notifications
            registerKeyboardNotifications()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            registerKeyboardNotifications()
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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


