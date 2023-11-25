//
//  FeedViewControllerTests.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 25/11/23.
//

import XCTest
import UIKit
import MyEssentialFeed

final class FeedViewController: UIViewController {
    
    private var loader: FeedLoader?
    
    // convenience initializer becase we don't need any custom initialization (in this way we don't need to implement UIViewController's required initializer)
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loader?.load { _ in }
    }
}


final class FeedViewControllerTests: XCTestCase {

    func test_init_doesNotLoadFeed() {
        
        let (_, loader) = makeSUT()
        
        XCTAssertEqual(loader.loadCallCount, 0)
    }
    
    
    func test_viewDidLoad_loadsFeed() {
        
        let (sut, loader) = makeSUT()
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loader.loadCallCount, 1)
    }
    
    
    // MARK: - Helpers
    
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
            
        let loader = LoaderSpy()
        let sut = FeedViewController(loader: loader)
        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loader)
    }
    
    class LoaderSpy: FeedLoader {

        private(set) var loadCallCount: Int = 0
        
        
        func load(completion: @escaping (MyEssentialFeed.LoadFeedResult) -> Void) {
            loadCallCount += 1
        }
        
    }
}
