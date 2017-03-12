//
//  ViewController.swift
//  TrackMySelf
//
//  Created by Dragos Neagu on 09/03/2017.
//  Copyright © 2017 Dragos Neagu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    var savedLocations : [[String: String]] = []
    
    let defaultsSettings = UserDefaults.standard
    var locationName : String = "Current Location"
    
    @IBAction func SaveLocationButton(_ sender: Any) {
        
        // First let's gather where the user is.
        let coordinate = locationManager.location?.coordinate
        
        let visitedPoint = VisitedPoint(latCoordinate: String(describing: coordinate?.latitude),
                                        longCoordinate: String(describing: coordinate?.longitude))
        
        // Creating a Modal with a text field which will ask the user to name
        // the location they are just about to save.
        let locationAlert = UIAlertController(title: "Where are you?", message: "Give this location a name", preferredStyle: .alert)
        
        // Use a closure to add a text field in the alert to ask for a location name
        locationAlert.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Location Name"
        }
        
        // If all variables would be class level then we could just call storeLocation 
        // in handler like so:
        // let addLocationAction = UIAlertAction(title: "Save Location", style: .default, handler: storeLocation)
        // But we want to pass some data we gathered *from the text field* and
        // therefore it can't be a closure by itself.
        let addLocationAction = UIAlertAction(title: "Save Location", style: .default, handler: {
            alert -> Void in
            
            self.storeLocation(locationName:  locationAlert.textFields![0].text! as String, visitedPoint: visitedPoint)
        })

        let cancelLocationAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        // Add both actions in this order, so "Cancel" is first.
        locationAlert.addAction(cancelLocationAction)
        locationAlert.addAction(addLocationAction)
        
        self.present(locationAlert, animated: true, completion: nil)

    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // Just using this to check if locations have been saved and loaded.
        // This should probably be the bit where I populate a UITableView 
        // TODO
        showUserLocations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Just checking if we have received permission to track location
        // when the user is in the app
        guard status == .authorizedWhenInUse else {
            print("Location not enabled")
            return
        }
        print("Location allowed")
        mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last! as CLLocation
        
        // We use this to center the map.
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        // Add an annotation popup with some information
        // This could be more explicit
        let point = MKPointAnnotation()
        point.coordinate = location.coordinate;
        point.title = "Where am I?";
        point.subtitle = "I'm here!!!";
        
        // Just keep updating the map
        self.mapView.addAnnotation(point)
        self.mapView.setRegion(region, animated: true)
    }
    
    // Hiding the status bar for a neater look.
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // This is called to append to SavedLocations array which is then saved
    // in UserDefaults.
    func storeLocation(locationName: String, visitedPoint: VisitedPoint) {
        savedLocations.append(["name" : locationName, "latitude": String(visitedPoint.latitude), "longitude" : String(visitedPoint.longitude)])
        saveUserLocations()
    }
    
    func saveUserLocations(){
        defaultsSettings.set(savedLocations, forKey: "SavedLocations")
        defaultsSettings.synchronize()
        
        // Just checking if it was saved.
        showUserLocations()
    }
    
    func showUserLocations(){
        if let loadedLocations = defaultsSettings.array(forKey: "SavedLocations") as? [[String: String]] {
            //print(loadedLocations)
            for item in loadedLocations {
                print("Location:"  + item["name"]!)
                print("Latitude:"  + item["latitude"]!)
                print("Longitude:" + item["longitude"]!)
                print("\n")
            }
        }
    }
    
}

