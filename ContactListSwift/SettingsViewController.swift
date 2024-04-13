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
    let sortOrderItems: [String] = ["contactName", "city", "birthday"]
    
    @IBOutlet weak var batteryLabel: UILabel!
    var settings = UserDefaults.standard
  
    override func viewDidLoad() {
        super.viewDidLoad()
        pckSortField.dataSource = self
        pckSortField.delegate = self
        loadSettings()
        
        // device information
        let device = UIDevice.current
        print("Device Info:")
        print("Name: \(device.name)")
        print("Model: \(device.model)")
        print("System Name: \(device.systemName)")
        print("Identifier: \(device.systemVersion)")
        
        
        let orientation: String
        switch device.orientation{
        case.faceDown:
            orientation = "Face Down"
        case.landscapeLeft:
            orientation = "Landscape Left"
        case.portrait:
            orientation = "Portrait"
        case.landscapeRight:
            orientation = "Landscape Right"
        case.faceUp:
            orientation = "Face Up"
        case.portraitUpsideDown:
            orientation = " Portrait Upside Down"
        case.unknown:
            orientation = " Unknown Orientation"
        @unknown default:
            fatalError()
        }
        print("Orientation: \(orientation)")
        
        pckSortField.dataSource = self;
        pckSortField.delegate = self;
        
        UIDevice.current.isBatteryMonitoringEnabled = true
           NotificationCenter.default.addObserver(self, selector: #selector(batteryChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
           NotificationCenter.default.addObserver(self, selector: #selector(batteryChanged), name: UIDevice.batteryLevelDidChangeNotification, object: nil)
           self.batteryChanged()
        
        }
    @objc func batteryChanged(){
        let device = UIDevice.current
        var batteryState: String
        switch device.batteryState {
            case .charging:
                batteryState = "+"
            case .full:
                batteryState = "!"
            case .unplugged:
                batteryState = "-"
            case .unknown:
                batteryState = "?"

        }
        let batteryLevelPercent = device.batteryLevel * 100
        let batteryLevel = String(format: "%.0f%%", batteryLevelPercent)
        let batteryStaus = "\(batteryLevel) (\(batteryState))"
        batteryLabel.text = batteryStaus
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
            settings.set("city", forKey: Constants.kSortField)
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


