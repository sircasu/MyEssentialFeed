//
//  FeedUIComposer.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 14/12/23.
//

import UIKit
import Combine
import MyEssentialFeed
import MyEssentialFeediOS

//public final class FeedUIComposer {
//    
//    private init() {}
//    
//    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: FeedImageDataLoader) -> FeedViewController {
//        
////        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: MainQueueDispatchDecorator(decoratee: feedLoader))
//
//
//        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader: { feedLoader().dispatchOnMainQueue() })
//        
//        
////        let refreshController = FeedRefreshViewController(delegate: presentationAdapter)
//        
////        let feedController = FeedViewController(refreshController: refreshController)
//        
//        let feedController = makeFeedViewController(delegate: presentationAdapter, title: FeedPresenter.title)
//                
//        // weakify with virtual proxy at the composition layer, in order to avoid  leaking implementation detail in the presenter
//        presentationAdapter.presenter = FeedPresenter(feedView: FeedViewAdapter(controller: feedController, 
//                                                                                imageLoader: MainQueueDispatchDecorator(decoratee:imageLoader)),
//                                                                                loadingView: WeakRefVirtualProxy(feedController),
//                                                                                errorView: WeakRefVirtualProxy(feedController)
//        )
//        
//        return feedController
//    }
//    
//    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
//        
//        let bundle = Bundle(for: FeedViewController.self)
//        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
//        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController // in this case the force casting is safe, because if this casting fails it's a developer error, and our test are covering this behaviour
//        
//        feedController.delegate = delegate
//        feedController.title = FeedPresenter.title
//        
//        return feedController
//    }
//
//    
//}

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) -> ListViewController {
        let presentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>(
            loader: { feedLoader().dispatchOnMainQueue() })
        
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: FeedPresenter.title)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(
                controller: feedController,
                imageLoader: { imageLoader($0).dispatchOnMainQueue() }),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )
        
        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! ListViewController
        feedController.delegate = delegate
        feedController.title = title
        return feedController
    }
}
