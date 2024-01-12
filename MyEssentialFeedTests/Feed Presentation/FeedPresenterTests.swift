//
//  FeedPresenterTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 12/01/24.
//

import XCTest

final class FeedPresenter {
    init(view: Any) {}
}

class FeedPresenterTests: XCTestCase {
    
    
    func test_init_doesNotSendMessageToView() {
        
        let view = ViewSpy()
        
        _ = FeedPresenter(view: view)
        
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    
    // MARK: - Helpers
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
