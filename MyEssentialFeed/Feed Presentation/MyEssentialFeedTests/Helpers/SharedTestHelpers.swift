//
//  SharedTestHelpers.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 31/10/23.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    return URL(string: "http://any-url.com")!
}
