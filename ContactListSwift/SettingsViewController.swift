//
//  SettingsViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/18/24.
//

import UIKit

class SettingsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pckSortField: UIPickerView!
    
    @IBOutlet weak var swAscending: UISwitch!
    let sortOrderItems: [String] = ["Contact Name", "City", "Birthday"]
    var settings = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        pckSortField.dataSource = self
        pckSortField.delegate = self
        loadSettings()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func sortDirectionChanged(_ sender: Any) {
        let settings = UserDefaults.standard
        settings.set(swAscending.isOn, forKey: Constants.kSortDirectionAscending)
        settings.synchronize()
        
    }
    func loadSettings() {
        // Load sort field setting
        if let sortField = settings.string(forKey: "sortField") {
            // Set picker view to saved sort field
            if let index = sortOrderItems.firstIndex(of: sortField) {
                pckSortField.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        // Load sort direction setting
        swAscending.isOn = settings.bool(forKey: "sortDirectionAscending")
    }
    
    // MARK: - UIPickerViewDataSource Methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sortOrderItems.count
    }
    
    // MARK: - UIPickerViewDelegate Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sortOrderItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedSortField = sortOrderItems[row]
        let settings = UserDefaults.standard
        settings.set(selectedSortField, forKey: Constants.kSortField)
        settings.synchronize()
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let settings = UserDefaults.standard
        
        if settings.string(forKey: Constants.kSortField) == nil {
            settings.set("City", forKey: Constants.kSortField)
        }
        
        if settings.string(forKey: Constants.kSortDirectionAscending) == nil {
            settings.set(true, forKey: Constants.kSortDirectionAscending)
        }
        
        settings.synchronize()
        
        NSLog("Sort field: %@", settings.string(forKey: Constants.kSortField)!)
       NSLog("Sort direction: \(settings.bool(forKey: Constants.kSortDirectionAscending))")
        
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set the UI based on values in UserDefaults
        let settings = UserDefaults.standard
        
        swAscending.setOn(settings.bool(forKey: Constants.kSortDirectionAscending), animated: true)
        
        if let sortField = settings.string(forKey: Constants.kSortField) {
            var i = 0
            for field in sortOrderItems {
                if field == sortField {
                    pckSortField.selectRow(i, inComponent: 0, animated: false)
                    break
                }
                i += 1
            }
        }
        
        pckSortField.reloadComponent(0)
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


