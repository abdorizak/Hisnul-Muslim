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
    
//    func fetchData() -> [HSMSchedulers]? {
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
//        do {
//            guard let result = try context?.fetch(fetchRequest) as? [HSMSchedulers] else {
//                return nil
//            }
//            print(result)
//            return result
//        } catch {
//            print("Failed to fetch data: \(error.localizedDescription)")
//            return nil
//        }
//    }
    
    func fetchData(completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        guard let context = context else {
            completion(.failure(HSErrors.invalidContext))
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            let scheduler = result.first!
            scheduler.willAccessValue(forKey: nil)
//            print("ABC: \(scheduler)")
            completion(.success(result))
        } catch {
            print("Failed to fetch data: \(error.localizedDescription)")
            completion(.failure(error))
        }
    }



    
    func insert(id: Int, adkarName: String, hour: Int, minute: Int) -> String {
        guard let entity = NSEntityDescription.entity(forEntityName: "HSMSchedulerNotifications", in: context!) else {
            return "Failed to save data: entity not found"
        }
        let dataObject = NSManagedObject(entity: entity, insertInto: context)
        dataObject.setValue(id, forKey: "id")
        dataObject.setValue(adkarName, forKey: "adkarName")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        var msg: String = ""
        do {
            try context?.save()
            msg = "Data saved successfully."
            return msg
        } catch {
            msg = "Failed to save data: \(error.localizedDescription)"
            return msg
        }
    }
    
    func insert(adkarName: String, hour: String, minute: String) -> String {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        fetchRequest.predicate = NSPredicate(format: "adkarName == %@", adkarName)
        do {
            let results = try context?.fetch(fetchRequest)
            if results?.count ?? 0 > 0 {
                return "Failed to save data: record with adkarName \(adkarName) already exists"
            }
        } catch {
            return "Failed to save data: \(error.localizedDescription)"
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "HSMSchedulerNotifications", in: context!) else {
            return "Failed to save data: entity not found"
        }
        let dataObject = NSManagedObject(entity: entity, insertInto: context)
        let id = UUID()
        dataObject.setValue(id, forKey: "id")
        dataObject.setValue(adkarName, forKey: "adkarName")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        do {
            try context?.save()
            return "Data saved successfully."
        } catch {
            return "Failed to save data: \(error.localizedDescription)"
        }
    }

    
    func update(dataObject: NSManagedObject, adkarName: String, hour: String, minute: String) -> String {
        dataObject.setValue(adkarName, forKey: "adkarName")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        var msg: String = ""
        do {
            try context?.save()
            msg = "Data updated successfully."
            return msg
        } catch {
            msg = "Failed to update data: \(error.localizedDescription)"
            return msg
        }
    }
    
}

