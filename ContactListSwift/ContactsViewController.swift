//
//  ContactsViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/18/24.
//

import UIKit
import CoreData
class ContactsViewController: UIViewController, DateControllerDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

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
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var bdaylabel: UILabel!
    
    @IBOutlet weak var btnChange: UISegmentedControl!
    
    @IBOutlet weak var phoneLabel: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(sgmtEditMode)
        
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        let textFields: [UITextField] = [textFieldContact, textFieldAddress, textFieldCity, textFieldState, textFieldZipCode, textFieldCellPhone, textFieldHomePhone, textFieldEmail]
               for textField in textFields {
                   textField.delegate = self
               }
            
               registerKeyboardNotifications()
               
        if let contact = currentContact {
                    populateFields(with: contact)
                    if let imageData = currentContact?.image as? Data {
                        imageLabel.image = UIImage(data: imageData)
                        
                       
                    }
                }
            }
           
           func populateFields(with contact: Contact) {
               textFieldContact.text = contact.contactName
               textFieldAddress.text = contact.streetAddress
               textFieldCity.text = contact.city
               textFieldState.text = contact.state
               textFieldZipCode.text = contact.zipCode
               textFieldCellPhone.text = contact.cellNumber
               textFieldHomePhone.text = contact.homeNumber
               textFieldEmail.text = contact.email
               
               if let birthday = contact.birthday {
                   let formatter = DateFormatter()
                   formatter.dateStyle = .short
                   bdaylabel.text = formatter.string(from: birthday)
               }
               if let imageData = currentContact?.image {
                   imageLabel.image = UIImage(data: imageData)
               }
               let longPress = UILongPressGestureRecognizer.init(target: self,
                                                                 action: #selector(callPhone(gesture:)))
               phoneLabel.addGestureRecognizer(longPress)
           
           }
           
           @objc func dismissKeyboard() {
               view.endEditing(true)
           }
    @objc func callPhone(gesture: UILongPressGestureRecognizer) {
       if gesture.state == .began {
           let number = textFieldCellPhone.text
           if number!.count > 0 {
               let url = URL(string: "telprompt://\(number!)")
               UIApplication.shared.open(url!, options: [:], completionHandler: nil)
           }
       }
   }
         
    @objc func textFieldShouldReturn(_ textField: UITextField) -> Bool {
               textField.resignFirstResponder()
               return true
           }

           @objc func keyboardDidShow(notification: Notification) {
               guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
                   return
               }
               let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
               scrollView.contentInset = contentInsets
               scrollView.scrollIndicatorInsets = contentInsets
           }
           
           @objc func keyboardWillHide(notification: Notification) {
               scrollView.contentInset = .zero
               scrollView.scrollIndicatorInsets = .zero
           }


           
           @IBAction func changeEditMode(_ sender: UISegmentedControl) {
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
                   navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContact))
               }
           }
           
           @objc func saveContact() {
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
                       
                       appDelegate.saveContext()
                       
                       sgmtEditMode.selectedSegmentIndex = 0
                       changeEditMode(sgmtEditMode)
                   }
                   
    @IBAction func takePicture(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraController = UIImagePickerController()
            cameraController.sourceType = .camera
            cameraController.cameraCaptureMode = .photo
            cameraController.delegate = self
            cameraController.allowsEditing = true
            self.present(cameraController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                imageLabel.contentMode = .scaleAspectFit
                imageLabel.image = image
                if currentContact == nil {
                    let context = appDelegate.persistentContainer.viewContext
                    currentContact = Contact(context: context)
                }
                currentContact?.image = image.jpegData(compressionQuality: 1.0)
                dismiss(animated: true, completion: nil)
            }
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
       }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


