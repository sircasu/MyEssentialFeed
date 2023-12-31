//
//  CoreDataHelpers.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 12/11/23.
//

import CoreData

internal extension NSPersistentContainer {
    
    internal enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistanceStore(Swift.Error)
    }
    
    
    internal static func load(modelName name: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        let description = NSPersistentStoreDescription(url: url)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistanceStore($0) }
        
        return container
    }
    
}


internal extension NSManagedObjectModel {
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
                .url(forResource: name, withExtension: "momd")
                .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}
