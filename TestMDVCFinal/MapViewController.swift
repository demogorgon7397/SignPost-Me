//
//  MapViewController.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 23/04/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var namelabel: UILabel!

    @IBOutlet weak var mV: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()

        // Do any additional setup after loading the view.
        
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        if let detail = mapDetailItem {
        
            if let name = detail.value(forKey: "name") as? String {
                if let lat = detail.value(forKey: "latitude") as? String {
                    if let lon = detail.value(forKey: "longitude") as? String {
                        
                        let annotation = MKPointAnnotation()
                        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                        let coordinate = CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(lon)!)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        
                        annotation.title = name
                        annotation.coordinate = coordinate
                        
                        mV.setRegion(region, animated: true)
                        self.mV.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print(locations)
        
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta: CLLocationDegrees = 0.05
        let lonDelta: CLLocationDegrees = 0.05
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        self.mV.setRegion(region, animated: true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func configureView() {
    
        if let detail = mapDetailItem {
        
            if let name = namelabel {
            
                name.text = detail.value(forKey: "name") as? String
                
            }
            
        }
    
    }
        // Update the user interface for the detail item.
   
    var mapDetailItem: Place? {
        
        
        didSet {
            // Update the view.
            configureView()
            //configureMapView()
        }
        
    }
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
