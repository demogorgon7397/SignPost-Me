//
//  WbebsiteViewController.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 25/04/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import UIKit

class WebsiteViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureWebsiteView()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureWebsiteView() {
        
            if let detail = websiteDetailItem {
        
                if let web = webView {
                    if Reachability.isConnectedToNetwork() {
                        
                        if let url = URL(string: (detail.value(forKey: "website") as! String)) {
                
                            web.loadRequest(URLRequest(url: url))
                            
                        }
                    } else {
                        let alert = UIAlertController(title: "No Internet Connection!", message: "Please, connect to the internet to continue.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }; title = detail.value(forKey: "name") as? String
            }
        }
    
    var websiteDetailItem: Place? {

        didSet {
            // Update the view.
            configureWebsiteView()
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
