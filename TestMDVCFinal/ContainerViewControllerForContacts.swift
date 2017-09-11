//
//  ContainerViewControllerForContacts.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 04/05/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import UIKit

class ContainerViewControllerForContacts: UIViewController {

    @IBOutlet weak var phone: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureView()
        
    }
    func configureView() {
    
        if let detail = containerDetailItem {
        
            if let number = phone {
                number.text = detail.value(forKey: "phoneNumber") as? String
                
            }
            
        }
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    var containerDetailItem: Place? {
        
        
        didSet {
            // Update the view.
            configureView()
            //configureMapView()
        }
    }
}
