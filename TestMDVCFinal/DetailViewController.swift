//
//  DetailViewController.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 08/04/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var descrption: UITextView!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var openningHours: UITextView!
    
    @IBOutlet weak var websiteButton: UIButton!
    
    
    
    @IBAction func button(_ sender: Any) {

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toMap" {
        
            let mapViewController = (segue.destination as! UINavigationController).topViewController as! MapViewController
            mapViewController.mapDetailItem = detailItem
            
        } else if segue.identifier == "toWebsite" {
        
            let websiteViewController = (segue.destination as! UINavigationController).topViewController as! WebsiteViewController
            websiteViewController.websiteDetailItem = detailItem
            
        } /*else if segue.identifier == "toContainer" {
        
            let containerViewControllerForContacts = segue.destination as! ContainerViewControllerForContacts
            containerViewControllerForContacts.containerDetailItem = detailItem
            
        }*/
    }
    
 
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            title = detail.value(forKey: "name") as? String
            
            if let number = phoneNumber {
                number.text = detail.value(forKey: "phoneNumber") as? String
                
            };  if let ws = websiteButton {
            
                ws.setTitle(detail.value(forKey: "website")as? String, for: UIControlState.normal)
                //ws.titleLabel?.minimumScaleFactor = 0.5
                //ws.titleLabel?.numberOfLines = 1
                //ws.titleLabel?.adjustsFontForContentSizeCategory = true
                
            };     if let oh = openningHours{
                    let a = detail.value(forKey: "opening_hours") as! String
                oh.text = a.replacingOccurrences(of: "\\n", with: "\n")
                oh.text = a.replacingOccurrences(of: ",", with: "\n")
                
            }; if let des = descrption {
            
                des.text = detail.value(forKey: "descriptionOfThePlace") as? String
            
            }; if let em = email {
            
                em.text = detail.value(forKey: "email") as? String
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = UIColor.lightGray
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
        //configureMapView()
        if let detail = detailItem {
            
            if let name = detail.value(forKey: "name") as? String {
                if let lat = detail.value(forKey: "latitude") as? String {
                    if let lon = detail.value(forKey: "longitude") as? String {
                        
                        let annotation = MKPointAnnotation()
                        let span = MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06)
                        let coordinate = CLLocationCoordinate2D(latitude: Double(lat)! , longitude: Double(lon)!)
                        let region = MKCoordinateRegion(center: coordinate, span: span)
                        
                        annotation.title = name
                        annotation.coordinate = coordinate
                        
                        mapView.setRegion(region, animated: true)
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Place? {
        
        
        didSet {
            // Update the view.
            configureView()
            //configureMapView()
        }
        
    }
    

}

