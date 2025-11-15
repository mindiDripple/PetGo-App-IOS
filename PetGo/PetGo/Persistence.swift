//
// File: Persistence.swift
// App: PetGo
// Purpose: Provides the Core Data stack and programmatic model used by the app.
// Description: Configures NSPersistentContainer, defines the in-code NSManagedObjectModel
// for the FavoritePlace entity (id, title, category, address, rating, reviewsCount,
// latitude, longitude, phone, hoursText, distanceText) and sets a merge policy.
// Developer: N.D.C.Minsandi
// Date: 15/11/2025
//

import Foundation
import CoreData

// Singleton Core Data stack used by the app
final class PersistenceController {
    static let shared = PersistenceController()

    let container: NSPersistentContainer

    // Configure container with in-code model and load stores
    private init() {
        let model = Self.makeModel()
        container = NSPersistentContainer(name: "PetGoModel", managedObjectModel: model)
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unresolved Core Data error: \(error)")
            }
            // Prefer local changes on conflicts
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }

    // Builds the NSManagedObjectModel programmatically
    static func makeModel() -> NSManagedObjectModel {
        let model = NSManagedObjectModel()

        // Entity: FavoritePlace
        let entity = NSEntityDescription()
        entity.name = "FavoritePlace"
        entity.managedObjectClassName = "NSManagedObject"

        // Helper to define an attribute succinctly
        func attr(_ name: String, _ type: NSAttributeType, _ optional: Bool = false) -> NSAttributeDescription {
            let a = NSAttributeDescription()
            a.name = name
            a.attributeType = type
            a.isOptional = optional
            return a
        }

        entity.properties = [
            attr("id", .UUIDAttributeType),
            attr("title", .stringAttributeType),
            attr("category", .stringAttributeType),
            attr("address", .stringAttributeType, true),
            attr("rating", .doubleAttributeType),
            attr("reviewsCount", .integer32AttributeType),
            attr("latitude", .doubleAttributeType),
            attr("longitude", .doubleAttributeType),
            attr("phone", .stringAttributeType, true),
            attr("hoursText", .stringAttributeType, true),
            attr("distanceText", .stringAttributeType, true)
        ]

        model.entities = [entity]
        return model
    }
}
