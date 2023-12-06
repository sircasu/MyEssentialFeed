//
//  FeedViewControllerTests.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 25/11/23.
//

import XCTest
import UIKit
import MyEssentialFeed
import MyEssentialFeediOS


final class FeedViewControllerTests: XCTestCase {

    func test_loadFeedActions_requestFeedFromLoader() {
        
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded() // viewDidLoad
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading request once view before all the correct lifecycle are called")
        
//        sut.loadViewIfNeeded() // viewDidLoad
        sut.beginAppearanceTransition(true, animated: false) // viewVillAppear
        sut.endAppearanceTransition() // viewVillAppear + viewDidAppear
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
    
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once user initiates a load")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loader.loadCallCount, 3, "Expected a third loading request once user initiates another load")
        
        
    }
    
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false) // viewVillAppear
        sut.endAppearanceTransition() // viewVillAppear + viewDidAppear
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is loaded")
        
        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiates a reload")
        
        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    
    
    // MARK: - Helpers
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
            
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        sut.replaceRefreshControlWithFakeForiOS17Support()
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {

        private var completions = [(FeedLoader.Result) -> Void]()
        
        var loadCallCount: Int {
            return completions.count
        }
        
        
        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int) {
            completions[index](.success([]))
        }
        
        
    }
}



private extension FeedViewController {
    
    func replaceRefreshControlWithFakeForiOS17Support() {
        
        let fake = FakeRefreshControl()
        
        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
            
            refreshControl = fake
        }
    }
}


private extension FeedViewController {
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    var isShowingLoadingIndicator: Bool {
        return refreshControl?.isRefreshing == true
    }
}



private extension UIRefreshControl {
    
    func simulatePullToRefresh(){
        
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
            
        }
    }
}


private class FakeRefreshControl: UIRefreshControl {
    
    private var _isRefreshing = false
    
    override var isRefreshing: Bool { _isRefreshing }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}
