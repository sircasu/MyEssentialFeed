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
//        guard let _ = (scene as? UIWindowScene) else { return }
//        
//        let url = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
//        
//        let session = URLSession(configuration: .ephemeral)
//        let client = URLSessionHTTPClient(session: session)
//        let feedLoader = RemoteFeedLoader(url: url, client: client)
//        let imageLoader = RemoteFeedImageDataLoader(client: client)
//        
//        let feedViewController = FeedUIComposer.feedComposedWith(
//            feedLoader: feedLoader,
//            imageLoader: imageLoader)
//        
//        window?.rootViewController = feedViewController
//    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
        
        
        let remoteURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed/v1/feed")!
        

        let remoteClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let remoteFeedLoader = RemoteFeedLoader(url: remoteURL, client: remoteClient)
        let remoteImageLoader = RemoteFeedImageDataLoader(client: remoteClient)
        
        
        let localStoreURL = NSPersistentContainer
            .defaultDirectoryURL()
            .appendingPathComponent("feed-store.sqlite")
        
        let localStore = try! CoreDataFeedStore(storeURL: localStoreURL)
        let localFeedLoader = LocalFeedLoader(store: localStore, currentDate: Date.init)
        let localImageLoader = LocalFeedImageDataLoader(store: localStore)
        
        
        window?.rootViewController = FeedUIComposer.feedComposedWith(
            feedLoader: FeedLoaderWithFallbackComposite(primary: remoteFeedLoader, fallback: localFeedLoader),
            imageLoader: FeedImageDataLoaderWithFallbackComposite(primary: localImageLoader, fallback: remoteImageLoader))
    }
}

