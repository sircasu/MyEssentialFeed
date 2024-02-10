//
//  FeedItemsMapperTest.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 06/10/23.
//

import XCTest
import MyEssentialFeed


final class FeedItemsMapperTest: XCTestCase {
    
    
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        
        let json = makeItemJSON([])
        let samples = [199, 201, 300, 404, 500]
        
        try samples.forEach { code in
           
            XCTAssertThrowsError(
                try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
            
        }

    }
    
    
    
    func test_map_throwsErrorOn200HTTPResponeWithInvalidJSON() {

        let invalidJSON = Data("invalid json".utf8)
        
        XCTAssertThrowsError(
            try FeedItemsMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    
    }
    
    
    func test_map_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        
         
        let emptyListJSON = makeItemJSON([])

        let result = try FeedItemsMapper.map(emptyListJSON, from: HTTPURLResponse(statusCode: 200))

        XCTAssertEqual(result, [])
    }
    
    
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {

        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "http://a-url.com")!
        )
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "http://another-url.com")!
        )
        
    
        let json = makeItemJSON([item1.json, item2.json])

        let result = try FeedItemsMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        XCTAssertEqual(result, [item1.model, item2.model])

    }
    
    
    // MARK: - Helpers

    
    private func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedImage, json: [String: Any]) {
        
        let item = FeedImage(id: id, description: description, location: location, url: imageURL)
        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }
        
        return (item, json)
    }

}



