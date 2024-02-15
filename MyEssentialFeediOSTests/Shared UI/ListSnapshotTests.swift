//
//  ListSnapshotTests.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 14/02/24.
//

import XCTest
import MyEssentialFeediOS
@testable import MyEssentialFeed

final class ListSnapshotTests: XCTestCase {

    
    func test_emptyList() {
        
        let sut = makeSUT()
         
        sut.display(emptyList())
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "EMPTY_LIST_light")
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "EMPTY_LIST_dark")
    }
    
    // TODO
//    func test_listWithErrorMessage() {
//        let sut = makeSUT()
//        
//        sut.display(.error(message: "This is a\nmultiline\nerror message"))
//        
//        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "LIST_WITH_ERROR_MESSAGE_light")
//        assert(snapshot: sut.snapshot(for: .iPhone8(style: .dark)), named: "LIST_WITH_ERROR_MESSAGE_dark")
//    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! ListViewController
        controller.loadViewIfNeeded()
        controller.tableView.showsVerticalScrollIndicator = false
        controller.tableView.showsHorizontalScrollIndicator  = false
        return controller
    }
    
    private func emptyList() -> [CellController] {
        return []
    }
}
