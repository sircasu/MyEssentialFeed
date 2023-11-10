//
//  CoreDataFeedStore.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 10/11/23.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", in: bundle)
        context = container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {}
    
    public func insert(_ feed: [MyEssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {}
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }

}




private extension NSPersistentContainer {
    
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistanceStore(Swift.Error)
    }
    
    
    static func load(modelName name: String, in bundle: Bundle) throws -> NSPersistentContainer {
        
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }
        
        
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistanceStore($0) }
        
        return container
    }
    
}



private extension NSManagedObjectModel {
    
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
                .url(forResource: name, withExtension: "momd")
                .flatMap { NSManagedObjectModel(contentsOf: $0) }
    }
}


private class ManagedCache: NSManagedObject {
    @NSManaged var timestamp: Date
    @NSManaged var feed: NSOrderedSet
}

private class ManageFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}