//
//  CoreDataHelper.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/22/23.
//

import UIKit
import CoreData

final class HSMCoreDataHelper {
    static let shared = HSMCoreDataHelper()
    private let appDelegate: AppDelegate?
    private let context: NSManagedObjectContext?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    func fetchData() -> [HSMSchedulers]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        do {
            guard let result = try context?.fetch(fetchRequest) as? [HSMSchedulers] else {
                return nil
            }
            return result
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            return nil
        }
    }
    
    func insert(id: Int, name: String, hour: Int, minute: Int) {
        guard let entity = NSEntityDescription.entity(forEntityName: "HSMSchedulersList", in: context!) else {
            return
        }
        let dataObject = NSManagedObject(entity: entity, insertInto: context)
        dataObject.setValue(id, forKey: "id")
        dataObject.setValue(name, forKey: "name")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        do {
            try context?.save()
            print("Data saved successfully.")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func update(dataObject: NSManagedObject, name: String, hour: Int, minute: Int) {
        dataObject.setValue(name, forKey: "name")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        do {
            try context?.save()
            print("Data updated successfully.")
        } catch {
            print("Failed to update data: \(error.localizedDescription)")
        }
    }
    
    func saveContext() {
        guard let context = context else {
            return
        }
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

