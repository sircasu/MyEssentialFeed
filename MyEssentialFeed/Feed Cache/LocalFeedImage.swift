//
//  LocalFeedImage.swift
//  MyEssentialFeed
//
//  Created by Matteo Casu on 30/10/23.
//

import Foundation

// This is our Feed Item representation for the Cache Module` - DTO data transfer object - data transfer of the model to remove strong coupling between modules
public struct LocalFeedImage: Equatable {
    public let id: UUID
    public let description: String?
    public let location: String?
    public let url: URL
    
    public init(id: UUID, description: String?, location: String?, url: URL) {
        self.id = id
        self.description = description
        self.location = location
        self.url = url
    }
}
