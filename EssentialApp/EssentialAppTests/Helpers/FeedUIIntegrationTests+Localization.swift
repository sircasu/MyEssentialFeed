//
//  FeedUIIntegrationTests+Localization.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 29/12/23.
//

import Foundation
import XCTest
import MyEssentialFeed

extension FeedUIIntegrationTests {
    
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }
    
    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }
    
    var feedTitle: String {
        FeedPresenter.title
    }   
    
    var commentsTitle: String {
        ImageCommentsPresenter.title
    }
    
}

