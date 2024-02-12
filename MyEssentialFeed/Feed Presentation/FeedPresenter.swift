//
//  FeedPresenter.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 12/01/24.
//

import Foundation


public final class FeedPresenter {
   
    
    public static var title: String {
        return NSLocalizedString("FEED_VIEW_TITLE",
                                 tableName: "Feed",
                                 bundle: Bundle(for: FeedPresenter.self),
                                 comment: "Title for the feed view")
    }
    

    
    public static func map(feed: [FeedImage]) -> FeedViewModel {
        FeedViewModel(feed: feed)
    }
}
