//
//  ImageCommentsLocalizationTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 13/02/24.
//

import XCTest
import MyEssentialFeed

final class ImageCommentsLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "ImageComments"
        let bundle = Bundle(for: ImageCommentsPresenter.self)

        assertLocalizedKeyAndValueExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {

        func display(_ viewModel: Any) {}
    }
}
