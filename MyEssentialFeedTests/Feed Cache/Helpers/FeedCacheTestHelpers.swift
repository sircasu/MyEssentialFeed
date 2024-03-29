//
//  FeedCacheTestHelpers.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 31/10/23.
//

import Foundation
import MyEssentialFeed


func uniqueImage() -> FeedImage {
    return FeedImage(id: UUID(), description: "a desc", location: "a loc", url: anyURL())
}



func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    
    return (items, localItems)
}



extension Date {
    
    func minusFeedCacheMaxAge() -> Date {
        return adding(days: -feedCacheMaxAgeInDays)
    }
    
    private var feedCacheMaxAgeInDays: Int {
        return 7
    }
    
    
}

