//
//  EssentialAppUIAcceptanceTests.swift
//  EssentialAppUIAcceptanceTests
//
//  Created by Matteo Casu on 26/01/24.
//

import XCTest

final class EssentialAppUIAcceptanceTests: XCTestCase {

    func test_onLaunch_displaysRemoteFeedWhenCustomerHasConnectivity() {
    
        // given
        let app = XCUIApplication()
        
        // when
        app.launch()
        
        // then
//        let feedCells = app.cells.matching(identifier: "feed-image-cell")
//        XCTAssertEqual(feedCells.count, 22)
//        
//        let firstImage = app.images.matching(identifier: "feed-image-view").firstMatch
//        XCTAssertTrue(firstImage.exists)
        
        let feedCells = app.cells
        XCTAssertEqual(feedCells.count, 22)
        
        let firstImage = app.images.firstMatch
        XCTAssertTrue(firstImage.exists)

    }
}
