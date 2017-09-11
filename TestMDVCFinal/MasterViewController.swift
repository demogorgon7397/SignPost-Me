//
//  MasterViewController.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 08/04/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating, UISearchControllerDelegate{
    
    // Declare context and detailViewController and set it to nil so they can be initialised later
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    // declare controller to initialise later set it to nil
    var _fetchedResultsController: NSFetchedResultsController<Place>? = nil
    
    var searchController: UISearchController! // declare searchController instance
    var searchPredicate: NSPredicate? = nil // declare a serach predicate

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create the search controller with this controller displaying the search results
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.sizeToFit()
        self.tableView.tableHeaderView = self.searchController?.searchBar
        self.tableView.delegate = self
        self.definesPresentationContext = true
        self.tableView.isHidden = false
        self.searchController.searchBar.placeholder = "Search a keyword: e.g Epilepsy"
        // call parseJson function when view loads
        processJson()
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 2000, height: 100))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "logo-1")
        imageView.image = image
        navigationItem.titleView = imageView
    }
    override func viewDidAppear(_ animated: Bool) {
        // I want to make the searchbar first responder so user can start searching staright away
        
        self.searchController.searchBar.becomeFirstResponder()
        //self.searchController.isActive = false
        //self.searchController.searchBar.delegate = self as? UISearchBarDelegate
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = self.searchController?.searchBar.text
        if let searchText = searchText {
            self.searchPredicate = searchText.isEmpty ? nil : NSPredicate(format: "name contains[c] %@ || tag contains[c] %@", searchText, searchText)
                self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"  {
            if let indexPath = tableView.indexPathForSelectedRow {
            
                let object = self.searchPredicate == nil ?
                self.fetchedResultsController.object(at: indexPath) as Place :
                
                    self.fetchedResultsController.fetchedObjects?.filter() {
                        return self.searchPredicate!.evaluate(with: $0)
                    }[indexPath.row]
   
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }


    // MARK: - Table View
    // return number of sections using fetchedResultsController's sections property: sections:[NSFetchedResultsSectionInfo] this array includes: section name for header, indexTitle for indexes on the right, numberOfObjects in the section, objects in the section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // Here numberOfObjects property of NSFetchedResultsSectionInfo is used to get the number of row in a given section. now I have only one section, so easy one
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchPredicate == nil {
            let sectionInfo = self.fetchedResultsController.sections![section]
            return sectionInfo.numberOfObjects
        } else {
            let filteredObjects = self.fetchedResultsController.fetchedObjects?.filter() {
                return self.searchPredicate!.evaluate(with: $0)
            }
            return filteredObjects == nil ? 0 : filteredObjects!.count
        }
    }
    // create a cell from cellForRowAt indexPath and configure cell using this index path
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
        }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
 
    
    // this method creates place instance of Place entity using object property of NSFetchedResultsSectionInfo
    func configureCell(_ cell: UITableViewCell, atIndexPath indexPath: IndexPath) {
        
        let place = self.searchPredicate == nil ?
            self.fetchedResultsController.object(at: indexPath) as Place :
            self.fetchedResultsController.fetchedObjects?.filter() {
                return self.searchPredicate!.evaluate(with: $0)
                }[indexPath.row]
    
        // make the separator to be full to the left margin
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
 
        // fill the cell with name and website value of place instance
        cell.textLabel!.text = place?.value(forKey: "name") as? String 
        cell.detailTextLabel!.text = place?.value(forKey: "address") as? String
        cell.textLabel?.textColor = UIColor.goodGreen()
        //cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
    }
    
    // MARK: - Fetched results controller
    
    // check whether fetchedResultsController craeted and initialised. if yes return to this
    var fetchedResultsController: NSFetchedResultsController<Place> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        // if no, send request using the entity name
        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
        
        // add the sort descriptor. the table view is sorted by this value of the object
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // create fetchedResultsController using core data context with cache
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "Place")
        aFetchedResultsController.delegate = self // set deleagte to parent instance
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch() // perform fetch
        } catch {
            
             print("Couldn't perform the fetch")
        }
        
        return _fetchedResultsController!
    }    
    
    // controller changes content when the data returned from server filled in the cell. this NSFetchedResultsControllerDelegate method notifies the MasterViewController that its table view is about to change. Because delegate for fetchedResultsController is MasterViewController
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
            case .insert:
                tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            case .delete:
                tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            default:
                return
        }
    }
    // another NSFetchedResultsControllerDelegate method. This method is implemented as MasterViewController uses this to animate insertion of row in the table as well as deleting and moving of the rows
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            
            case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete:
                tableView.deleteRows(at: [indexPath!], with: .fade)
            case .update:
                configureCell(tableView.cellForRow(at: indexPath!)!, atIndexPath: indexPath!)
            case .move:
                tableView.deleteRows(at: [indexPath!], with: .fade)
                tableView.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    // this is NSFetchedResultsControllerDelegate method to tell the MasterViewController it is about to end the updates to the tableview
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        tableView.endUpdates()
    }
    
    
    func processJson() {
        
        // send a request to the server
        let address = "https://signpostme.herokuapp.com/places.json"
        let url = URL(string: address)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in

            if error != nil { // if there is an error
                print("URL not found/ 404") // print this to the console
            } else {
                
                if let urlContent = data { // if not get the json results
                    
                    do {
                        
                        // convert the results into an array
                        let resultFromJson = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                        
                        // get context from fetchedResultsController
                        let context = self.fetchedResultsController.managedObjectContext
                        // send a fetch request
                        let fetchRequest: NSFetchRequest<Place> = Place.fetchRequest()
                        
                        do {
                            
                            let resultsArray = try context.fetch(fetchRequest)
                            
                            if resultsArray.count > 0 {
                                
                                for result in resultsArray {
                                    
                                    context.delete(result) // delete context if there is anything in the context
                                    
                                    do {
                                        
                                        try context.save() // save the context to make sure there is nothing in there
                                        
                                    } catch {
                                        
                                        print("Failed to delete specifically")
                                    }
                                }
                            }
                            
                        } catch {
                            
                            print("Failed to delete the context")
                            
                        }
                        // parse json
                        for jr in resultFromJson as! [NSDictionary] {
                            
                            
                            let address = jr["address"]
                            print (address!)
                            let name = jr["name"]
                            print (name!)
                            //let id = jr["id"]
                            //print (id!)
                            let phone = jr["phone"]
                            //print (phone!)
                            let lat = jr["lat"]
                            //print(lat!)
                            let lng = jr["lng"]
                            //print(lng!)
                            let opening_hours = jr["opening_hours"]
                            print(opening_hours!)
                            let website = jr["website"]
                            //print(website!)
                            let email = jr["email"]
                            //print(email!)
                            let descriptionOfThePlace = jr["description"]
                            print(descriptionOfThePlace!)
                            let tag = jr["tag"]
                            //print(tag!)
                            let category = jr["category"]
                            //print(category!)
         
                            // fill the context with new values that returned from http
                            let newPlace = Place(context: context)
                            
                            newPlace.setValue(name, forKey: "name")
                            newPlace.setValue(phone, forKey: "phoneNumber")
                            newPlace.setValue(website, forKey: "website")
                            newPlace.setValue(lat, forKey: "latitude")
                            newPlace.setValue(lng, forKey: "longitude")
                            newPlace.setValue(opening_hours, forKey: "opening_hours")
                            newPlace.setValue(email, forKey: "email")
                            newPlace.setValue(descriptionOfThePlace, forKey: "descriptionOfThePlace")
                            newPlace.setValue(tag, forKey: "tag")
                            newPlace.setValue(category, forKey: "category")
                            newPlace.setValue(address, forKey: "address")
 
                        
                            // Save the context.
                            do {
                                try context.save()
                                
                                }catch {
                                
                                    print("Couldn't save the data after getting json results")
                                }
                            self.tableView.reloadData()
                            }
                        
                        } catch {
                        
                            print ("JSON COULDNT BE PROCESSED")
                    }
                }
            }
        }
        task.resume()
    }
}

