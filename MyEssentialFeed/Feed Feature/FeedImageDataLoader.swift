//
//  FeedImageDataLoader.swift
//  MyEssentialFeediOS
//
//  Created by Matteo Casu on 13/12/23.
//

import Foundation

public protocol FeedImageDataLoader {
    func loadImageData(from url: URL) throws -> Data
}
