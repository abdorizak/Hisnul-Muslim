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
    
    func fetchData(completion: @escaping (Result<[NSManagedObject], Error>) -> Void) {
        guard let context = context else {
            completion(.failure(HSErrors.invalidContext))
            return
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            if result.isEmpty {
                completion(.success([]))
                return
            }
            let scheduler = result.first!
            scheduler.willAccessValue(forKey: nil)
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
    
    func insert(adkarName: String, hour: String, minute: String) -> (success: Bool, message: String, id: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        fetchRequest.predicate = NSPredicate(format: "adkarName == %@", adkarName)
        do {
            let results = try context?.fetch(fetchRequest)
            if results?.count ?? 0 > 0 {
                return (false, "Failed to save data: record with adkarName \(adkarName) already exists", nil)
            }
        } catch {
            return (false, "Failed to save data: \(error.localizedDescription)", nil)
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "HSMSchedulerNotifications", in: context!) else {
            return (false, "Failed to save data: entity not found", nil)
        }
        let dataObject = NSManagedObject(entity: entity, insertInto: context)
        let id = UUID()
        dataObject.setValue(id, forKey: "id")
        dataObject.setValue(adkarName, forKey: "adkarName")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        do {
            try context?.save()
            return (true, "Data saved successfully.", id.uuidString)
        } catch {
            return (false, "Failed to save data: \(error.localizedDescription)", nil)
        }
    }


    func deleteRecord(withID id: UUID, completion: @escaping (Result<Void, Error>) -> Void) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let results = try context?.fetch(fetchRequest) as? [NSManagedObject]
            guard let record = results?.first else {
                let error = NSError(domain: "com.abdorizak.Hisnul-Muslim", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found"])
                completion(.failure(error))
                return
            }
            context?.delete(record)
            try context?.save()
            completion(.success(()))
        } catch {
            completion(.failure(error))
        }
    }

 
}

