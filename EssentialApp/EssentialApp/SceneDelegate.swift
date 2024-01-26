//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Matteo Casu on 21/01/24.
//

import UIKit
import CoreData
import MyEssentialFeed
import MyEssentialFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        

//    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let _ = (scene as? UIWindowScene) else { return }

        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!

        let session = URLSession(configuration: .ephemeral)
        
        let remoteClient = makeRemoteClient()
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        #if DEBUG
        if CommandLine.arguments.contains("-reset") { // different way to get launch argument (instead of UserDefaults.standard that care about value)
            try? FileManager.default.removeItem(at: localStoreURL)
        }
        #endif

        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)

        window?.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(
                primary: FeedLoaderCacheDecorator(
                    decoratee: remoteFeedLoader, cache: localFeedLoader),
                fallback: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(
                primary: localImageLoader,
                fallback: FeedImageDataLoaderCacheDecorator(
                    decoratee: remoteImageLoader,
                    cache: localImageLoader)))
    }
    
    
    private func makeRemoteClient() -> HTTPClient {

        #if DEBUG
        if UserDefaults.standard.string(forKey: "connectivity") == "offline" {
            
            return AlwaysFailingHTTPClient()
        }
        #endif

        return URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }
}

#if DEBUG
private class AlwaysFailingHTTPClient: HTTPClient {
    
    private class Task: HTTPClientTask {
        func cancel() {}
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> MyEssentialFeed.HTTPClientTask {
        completion(.failure(NSError(domain: "offline", code: 0)))
        return Task()
    }
    
}
#endif
