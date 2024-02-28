//
//  SceneDelegate.swift
//  EssentialApp
//
//  Created by Matteo Casu on 21/01/24.
//

import os
import UIKit
import CoreData
import Combine
import MyEssentialFeed


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    private lazy var scheduler: AnyDispatchQueueScheduler = DispatchQueue(
        label: "com.matteocasu.infra.queue",
        qos: .userInitiated,
        attributes: .concurrent
    ).eraseToAnyScheduler()
    
    private lazy var httpClient: HTTPClient = {
        URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
    }()
    
    private lazy var logger = Logger(subsystem: "com.matteocasu.EssentialApp", category: "main")
    
    private lazy var store: FeedStore & FeedImageDataStore = {
        do {
            return try CoreDataFeedStore(storeURL: NSPersistentContainer
                .defaultDirectoryURL()
                .appendingPathComponent("feed-store.sqlite"))
        } catch {
            assertionFailure("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            logger.fault("Failed to instantiate CoreData store with error: \(error.localizedDescription)")
            return NullStore()
        }
        
    }()
    
    private lazy var localFeedLoader: LocalFeedLoader = {
        LocalFeedLoader(store: store, currentDate: Date.init)
    }()
    
    private lazy var baseURL = URL(string: "https://ile-api.essentialdeveloper.com/essential-feed")!
    
    private lazy var navigationController: UINavigationController = UINavigationController(
        rootViewController: FeedUIComposer.feedComposedWith(
            feedLoader: makeRemoteFeedLoaderWithLocalFallback,
            imageLoader: makeLocalImageLoaderWithRemoteFallback,
            selection: showComments
        ))
    
    
    convenience init(httpClient: HTTPClient, store: FeedStore & FeedImageDataStore, scheduler: AnyDispatchQueueScheduler) {
        self.init()
        self.httpClient = httpClient
        self.store = store
        self.scheduler = scheduler
    }
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: scene)
        configureWindow()
    }
    
    func configureWindow() {
        
        window?.rootViewController = navigationController
        
        window?.makeKeyAndVisible()
    }
    
    
    func sceneWillResignActive(_ scene: UIScene) {
        
        do {
            try localFeedLoader.validateCache()
        } catch {
            logger.error("Failed to validate cache with error: \(error.localizedDescription)")
        }
    }
    
    
    private func showComments(for image: FeedImage) {
        
        let url = ImageCommentsEndpoint.get(image.id).url(baseURL: baseURL)
        let comments = CommentsUIComposer.commentsComposedWith(commentsLoader: makeRemoteCommentsLoader(url: url))
        navigationController.pushViewController(comments, animated: true)
    }
    
    
    private func makeRemoteCommentsLoader(url: URL) -> () -> AnyPublisher<[ImageComment], Error> {
        return { [httpClient] in
            return httpClient
                .getPublisher(url: url)
                .tryMap(ImageCommentsMapper.map)
                .eraseToAnyPublisher()
        }
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<Paginated<FeedImage>, Error> {
        makeRemoteFeedLoader()
            .caching(to: localFeedLoader)
            .fallback(to: localFeedLoader.loadPublisher)
            .map(makeFirstPage)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteLoadMoreLoader(last: FeedImage?) -> AnyPublisher<Paginated<FeedImage>, Error> {
        localFeedLoader.loadPublisher()
            .zip(makeRemoteFeedLoader(after: last))
            .map { (cachedItems, newItems) in
                (cachedItems + newItems, newItems.last)
            }
            .map(makePage)
//            .delay(for: 2, scheduler: DispatchQueue.main)
//            .flatMap({ _ in
//                Fail(error: NSError())
//            })
            .caching(to: localFeedLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader(after: FeedImage? = nil) -> AnyPublisher<[FeedImage], Error> {
        let url = FeedEndpoint.get(after: after).url(baseURL: baseURL)
        
        return httpClient
            .getPublisher(url: url)
            .tryMap(FeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
    
    private func makeFirstPage(items: [FeedImage]) -> Paginated<FeedImage> {
        makePage(items: items, last: items.last)
    }
    
    private func makePage(items: [FeedImage], last: FeedImage?) -> Paginated<FeedImage> {
        Paginated(items: items, loadMorePublisher: last.map { last in
            { self.makeRemoteLoadMoreLoader(last: last) }
        })
    }
    
    private func makeLocalImageLoaderWithRemoteFallback(url: URL) -> FeedImageDataLoader.Publisher {
        let localImageLoader = LocalFeedImageDataLoader(store: store)
        
        return localImageLoader
            .loadImageDataPublisher(from: url)
//            .logCacheMisses(url: url, logger: logger)
            .fallback(to: { [httpClient/*, logger,*/, scheduler] in
                httpClient
                    .getPublisher(url: url)
//                    .logErrors(url: url, logger: logger)
//                    .logElapsedTime(url: url, logger: logger)
                    .tryMap(FeedImageDataMapper.map)
                    .caching(to: localImageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            })
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
}


extension Publisher {
    
    func logCacheMisses(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
                
        return handleEvents(

            receiveCompletion: { result in
                if case .failure = result {
                    logger.trace("Cache miss for url: \(url)")
                }

            }).eraseToAnyPublisher()
    }
    
    
    func logErrors(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
                
        return handleEvents(

            receiveCompletion: { result in
                if case let .failure(error) = result {
                    logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
                }

            }).eraseToAnyPublisher()
    }
    
        
    func logElapsedTime(url: URL, logger: Logger) -> AnyPublisher<Output, Failure> {
        
        var startTime = CACurrentMediaTime()
        
        return handleEvents(
            receiveSubscription: { [logger] _ in
                
                logger.trace("Started loading url: \(url)")
                startTime = CACurrentMediaTime()
            },
            receiveCompletion: { result in

                let elapsed = CACurrentMediaTime() - startTime
                logger.trace("Finished loading url: \(url) in \(elapsed) seconds")
                
            }).eraseToAnyPublisher()
    }
    
}

/* DECORATOR example
private class HTTPClientProfilingDecorator: HTTPClient {
    
    private var decoratee: HTTPClient
    private var logger: Logger
    
    init(decoratee: HTTPClient, logger: Logger) {
        self.decoratee = decoratee
        self.logger = logger
    }
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        
        logger.trace("Started loading url: \(url)")
        
        let startTime = CACurrentMediaTime()
        return decoratee.get(from: url) { [logger] result in
            
            if case let .failure(error) = result {
                logger.trace("Failed to load url: \(url) with error: \(error.localizedDescription)")
            }
            
            let elapsed = CACurrentMediaTime() - startTime
            logger.trace("Finished loading url: \(url) in \(elapsed) seconds")

            completion(result)
        }
    }
}
*/
