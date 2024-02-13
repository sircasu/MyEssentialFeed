//
//  ImageCommentsPresenterTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 13/02/24.
//

import XCTest
import MyEssentialFeed

final class ImageCommentsPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        
        XCTAssertEqual(ImageCommentsPresenter.title, localized("IMAGE_COMMENTS_VIEW_TITLE"))
    }
            
    
    
    // MARK: - Helpers
    
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
}
