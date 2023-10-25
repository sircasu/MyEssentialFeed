//
//  CacheFeedUseCaseTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 24/10/23.
//

import XCTest
import MyEssentialFeed


class LocalFeedLoader {
    
    private let store: FeedStore
    private let currentDate: () -> Date
    
    init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
    
    func save(_ items: [FeedItem], completion: @escaping (Error?) -> Void) {
        store.deleteCachedFeed { [unowned self] error in

            
            if error == nil {
                self.store.insert(items, timestamp: self.currentDate(), completion: completion)
            } else {
                completion(error)
            }
        }
    }
}

class FeedStore {
    
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    
    enum ReceivedMessage: Equatable {
        case deleteCacheFeed
        case insert([FeedItem], Date)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    
    
    private var deletionCompletions = [DeletionCompletion]()
    private var insertionCompletions = [InsertionCompletion]()
    
    
    
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
        deletionCompletions.append(completion)
        receivedMessages.append(.deleteCacheFeed)
    }
    
    
    func completeDeletion(with error: Error, at index: Int = 0) {
    
        deletionCompletions[index](error)
    }
    
    
    func completeDeletionSuccessfully(at index: Int = 0) {
        
        deletionCompletions[index](nil)
    }
    
    
    func insert(_ items: [FeedItem], timestamp: Date, completion: @escaping InsertionCompletion) {
        
        insertionCompletions.append(completion)
        receivedMessages.append(.insert(items, timestamp))
    }
    
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionCompletions[index](error)
    }
    
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionCompletions[index](nil)
    }
}


final class CacheFeedUseCaseTests: XCTestCase {

    
    func test_doesNotMessageStoreUponCreation() {
        
        let (_, store) = makeSut()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    
    
    func test_save_requestCacheDeletion() {
        
        let (sut, store) = makeSut()
        let items = [uniqueItem()]
        
        sut.save(items) { _ in }
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }
    
    
    
    func test_save_doesNotRequestCacheInsertionOnDeletionError() {
        
        let (sut, store) = makeSut()
        let items = [uniqueItem(), uniqueItem()]
        let deletionError = anyNSError()
        
        sut.save(items) { _ in }
        store.completeDeletion(with: deletionError)
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed])
    }

    
    
    
    func test_save_requestsNewCacheInsertioWithTimestampnOnSuccessfulDeletion() {
        let timestamp = Date()
        let (sut, store) = makeSut(currentDate: { timestamp })
        let items = [uniqueItem(), uniqueItem()]
        
        sut.save(items) { _ in }
        store.completeDeletionSuccessfully()
        
        XCTAssertEqual(store.receivedMessages, [.deleteCacheFeed, .insert(items, timestamp)])
    }
    
    
    
    
    func test_save_failOnDeletionError() {
        
        let (sut, store) = makeSut()
        let deletionError = anyNSError()
        
        expect(sut, toCompleteWithError: deletionError, when: {
            store.completeDeletion(with: deletionError)
        })
        
    }

        
    
    
    func test_save_failOnInsertionError() {
        
        let (sut, store) = makeSut()
        let insertionError = anyNSError()
        
        
        expect(sut, toCompleteWithError: insertionError, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertion(with: insertionError)
        })
    }

    
        
    func test_save_succedsOnSuccessfulCacheInsertion() {

        let (sut, store) = makeSut()
        
        expect(sut, toCompleteWithError: nil, when: {
            store.completeDeletionSuccessfully()
            store.completeInsertionSuccessfully()
        })
    }

    
    
    
    
    
    // MARK: - Helpers
    
    private func makeSut(currentDate: @escaping () -> Date = Date.init, file: StaticString = #file, line: UInt = #line) -> (sut: LocalFeedLoader, store: FeedStore) {
            
        let store = FeedStore()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    
    private func expect(_ sut: LocalFeedLoader, toCompleteWithError expectedError: NSError?, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for save completion")
        
        var receivedError: Error?
        sut.save([uniqueItem()]) { error in
            receivedError = error
            exp.fulfill()
        }
        
        action()
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedError as NSError?, expectedError, file: file, line: line)
    }
    
    
    private func uniqueItem() -> FeedItem {
        return FeedItem(id: UUID(), description: "a desc", location: "a loc", imageURL: anyURL())
    }
    

    
    
    private func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    
    
    private func anyNSError() -> NSError {
        return NSError(domain: "any error", code: 0)
    }
    
}
