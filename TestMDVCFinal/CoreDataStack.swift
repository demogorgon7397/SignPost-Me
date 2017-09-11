//
//  CoreDataStack.swift
//  TestMDVCFinal
//
//  Created by Orkhan Gasimov on 09/05/2017.
//  Copyright © 2017 Orkhan Gasimov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "TestMDVCFinal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    class func saveContext () {
        let context = CoreDataStack.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
}
