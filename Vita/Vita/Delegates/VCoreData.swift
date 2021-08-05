//
//  VCoreData.swift
//  Vita
//
//  Created by Chappy Asel on 8/4/21.
//

import CoreData
import Foundation

class VCoreData {
    static let shared = VCoreData()

    lazy var persistentContainer: NSPersistentCloudKitContainer = {
        let container = NSPersistentCloudKitContainer(name: "Vita")
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may be
                // useful during development.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var context: NSManagedObjectContext { return persistentContainer.viewContext }

    func save() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate.
                // You should not use this function in a shipping application, although it may
                // be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // TODO: remove test data code
    func loadTestData() {
        do {
            let journals: [Journal] = try context.fetch(Journal.fetchRequest())
            journals.forEach { persistentContainer.viewContext.delete($0) }
        } catch {
            fatalError("Journals not removed:\n\(error)")
        }

        guard let file = Bundle.main.url(forResource: "testData.json", withExtension: nil) else {
            fatalError("Test data not loaded")
        }

        do {
            let data = try Data(contentsOf: file)

            let decoder = VJSONDecoder()
            _ = try decoder.decode(Journal.self, from: data)
        } catch {
            fatalError("Couldn't parse test data:\n\(error)")
        }
    }
}
