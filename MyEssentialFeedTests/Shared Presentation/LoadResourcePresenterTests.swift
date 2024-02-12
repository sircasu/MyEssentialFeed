//
//  LoadResourcePresenterTests.swift
//  MyEssentialFeedTests
//
//  Created by Matteo Casu on 12/02/24.
//

import XCTest
import MyEssentialFeed

final class LoadResourcePresenterTests: XCTestCase {


    func test_init_doesNotSendMessageToView() {
        
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoading_displayNoErrorMessageAndStartsLoading() {
        
        let (sut, view) = makeSUT()
        
        sut.didStartLoading()
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: .none),
            .display(isLoading: true)
        ])
    }
    
    
    func test_didFinishLoadingResource_displaysResourceAndStopsLoading() {
        
        let (sut, view) = makeSUT(mapper: { resource in
            resource + " view model"
        })
        let resource = "resource"
        
        sut.didFinishLoading(with: resource)
        
        XCTAssertEqual(view.messages, [
            .display(resourceViewModel: "resource view model"),
            .display(isLoading: false)
        ])
    }
    
    
    func test_didFinishLoadingWithError_displaysLocalizedErrorMessageAndStopsLoading() {
        
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().models
        
        sut.didFinishLoading(with: anyNSError())
        
        XCTAssertEqual(view.messages, [
            .display(errorMessage: localized("GENERIC_CONNECTION_ERROR")),
            .display(isLoading: false)
        ])
    }
    
    // MARK: - Helpers
    private typealias SUT = LoadResourcePresenter<String, ViewSpy>
    
    private func makeSUT(
        mapper: @escaping SUT.Mapper = { _ in "any" },
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: SUT, view: ViewSpy) {
        
        let view = ViewSpy()
        let sut = LoadResourcePresenter(resourceView: view, loadingView: view, errorView: view, mapper: mapper)
        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, view)
    }
    
    
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Shared"
        let bundle = Bundle(for: SUT.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: ResourceView, ResourceLoadingView, ResourceErrorView {
        typealias ResourceViewModel = String
        
        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(resourceViewModel: String)
        }
         
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: ResourceErrorViewModel) {
            messages.insert(.display(errorMessage: viewModel.message))
        }
        
        func display(_ viewModel: ResourceLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
        
        func display(_ viewModel: String) {
            messages.insert(.display(resourceViewModel: viewModel))
        }
    }

}
