//
//  MapViewController.swift
//  ContactListSwift
//
//  Created by Celes Augustus on 3/18/24.
//

import UIKit
import MapKit
import CoreLocation
import CoreData


class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var sgmtMapType: UISegmentedControl!
    
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var minusButton: UIButton!
    var locationManager: CLLocationManager!
    var contacts: [Contact] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let tap: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: #selector (self.dismissKeyboard))
        //view.addGestureRecognizer(tap)
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("Permission Granted")
        } else {
            print("Permission NOT granted")
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
        
        // Do any additional setup after loading the view.
    }
    @IBAction func zoomIn(_ sender: Any) {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: min(region.span.latitudeDelta * 0.5, 180), longitudeDelta: min(region.span.longitudeDelta * 0.5, 180))
        let adjustedRegion = MKCoordinateRegion(center: region.center, span: span)
                mapView.setRegion(adjustedRegion, animated: true)
    }
    @IBAction func zoomOut(_ sender: Any) {
        let region = mapView.region
        let span = MKCoordinateSpan(latitudeDelta: min(region.span.latitudeDelta * 2.0, 180), longitudeDelta: min(region.span.longitudeDelta * 2.0, 180))
        let adjustedRegion = MKCoordinateRegion(center: region.center, span: span)
                mapView.setRegion(adjustedRegion, animated: true)
    }
    
    @IBAction func findUser(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    @objc(mapView:didUpdateUserLocation:) func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var span = MKCoordinateSpan()
        span.latitudeDelta = 0.2
        span.longitudeDelta = 0.2
        let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, span: span)
        mapView.setRegion(viewRegion, animated: true)
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "You"
        annotation.subtitle = "Are here"
        
        
        mapView.addAnnotation(annotation)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<Contact>(entityName: "Contact")
        
        do {
            contacts = try context.fetch(request)
            mapView.removeAnnotations(mapView.annotations)
            
            for contact in contacts {
                let address = "\(contact.streetAddress!), \(contact.city!), \(contact.state!)"
                let geoCoder = CLGeocoder()
                
                geoCoder.geocodeAddressString(address) { [weak self] (placemarks, error) in
                    if let error = error {
                        print("Geocode Error: \(error)")
                    } else if let placemark = placemarks?.first {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = placemark.location!.coordinate
                        annotation.title = contact.contactName
                        annotation.subtitle = address
                        self?.mapView.addAnnotation(annotation)
                    }
                }
            }
            
            
            mapView.showAnnotations(mapView.annotations, animated: true)
        } catch {
            print("Failed to fetch contacts: \(error)")
        }
    }
    
    @IBAction func mapTypeChnage(_ sender: Any) {
        switch sgmtMapType.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default: break
        }
    }
}
