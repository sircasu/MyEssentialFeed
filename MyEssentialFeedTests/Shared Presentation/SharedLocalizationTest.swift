//
//  SharedLocalizationTest.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 12/02/24.
//

import XCTest
import MyEssentialFeed

final class SharedLocalizationTest: XCTestCase {


    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Shared"
        let bundle = Bundle(for: LoadResourcePresenter<Any, DummyView>.self)

        assertLocalizedKeyAndValueExist(in: bundle, table)
    }
    
    private class DummyView: ResourceView {

        func display(_ viewModel: Any) {}
    }
    
    

}
