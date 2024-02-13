//
//  FeedImagePresenterTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 12/01/24.
//

import XCTest
import MyEssentialFeed



class FeedImagePresenterTests: XCTestCase {
    
    func test_map_createsViewModel() {
        let image = uniqueImage()
        
        let viewModel = FeedImagePresenter.map(image)
        
        XCTAssertEqual(viewModel.description, image.description)
        XCTAssertEqual(viewModel.location, image.location)
    }

}
