//
//  CoreDataHelper.swift
//  Hisnul Muslim
//
//  Created by Abdirizak Hassan on 3/22/23.
//

import UIKit
import CoreData

@MainActor
class HSMCoreDataHelper {
    static let shared = HSMCoreDataHelper()
    private let appDelegate: AppDelegate?
    private let context: NSManagedObjectContext?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
        context = appDelegate?.persistentContainer.viewContext
    }
    
    // async fetchData
    func fetchData() async throws -> [NSManagedObject] {
        guard let context = context else {
            throw HSErrors.invalidContext
        }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        
        return try await withCheckedThrowingContinuation { continuation in
            do {
                let result = try context.fetch(fetchRequest) as! [NSManagedObject]
                if result.isEmpty {
                    continuation.resume(returning: [])
                    return
                }
                let scheduler = result.first!
                scheduler.willAccessValue(forKey: nil)
                continuation.resume(returning: result)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    // async insert
    func insert(adkarName: String, hour: String, minute: String) async throws -> (success: Bool, message: String, id: String?) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        fetchRequest.predicate = NSPredicate(format: "hour == %@ AND minute == %@", hour, minute)
        
        do {
            let results = try await withCheckedThrowingContinuation { continuation in
                do {
                    let results = try context?.fetch(fetchRequest)
                    continuation.resume(returning: results)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            
            if results?.count ?? 0 > 0 {
                return (false, "فشل حفظ البيانات: التسجيل بالساعة \(hour) والدقيقة \(minute) موجود بالفعل", nil)
            }
        } catch {
            return (false, "Failed to save data: \(error.localizedDescription)", nil)
        }

        guard let entity = NSEntityDescription.entity(forEntityName: "HSMSchedulerNotifications", in: context!) else {
            return (false, "فشل حفظ البيانات: لم يتم العثور على الكيان", nil)
        }
        
        let dataObject = NSManagedObject(entity: entity, insertInto: context)
        let id = UUID()
        dataObject.setValue(id, forKey: "id")
        dataObject.setValue(adkarName, forKey: "adkarName")
        dataObject.setValue(hour, forKey: "hour")
        dataObject.setValue(minute, forKey: "minute")
        
        do {
            try await withCheckedThrowingContinuation { continuation in
                do {
                    try context?.save()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
            return (true, "تم حفظ المعلومات بنجاح.", id.uuidString)
        } catch {
            return (false, "فشل في حفظ البيانات: \(error.localizedDescription)", nil)
        }
    }


    func deleteRecord(withID id: UUID) async throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HSMSchedulerNotifications")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        guard let context = context else {
            throw NSError(domain: "com.abdorizak.Hisnul-Muslim", code: 500, userInfo: [NSLocalizedDescriptionKey: "Invalid context"])
        }

        let results: [NSManagedObject] = try await withCheckedThrowingContinuation { continuation in
            do {
                if let fetchedResults = try context.fetch(fetchRequest) as? [NSManagedObject] {
                    continuation.resume(returning: fetchedResults)
                } else {
                    let error = NSError(domain: "com.abdorizak.Hisnul-Muslim", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found"])
                    continuation.resume(throwing: error)
                }
            } catch {
                continuation.resume(throwing: error)
            }
        }

        guard let record = results.first else {
            throw NSError(domain: "com.abdorizak.Hisnul-Muslim", code: 404, userInfo: [NSLocalizedDescriptionKey: "Record not found"])
        }

        context.delete(record)

        try await withCheckedThrowingContinuation { continuation in
            do {
                try context.save()
                continuation.resume(returning: ())
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

}

