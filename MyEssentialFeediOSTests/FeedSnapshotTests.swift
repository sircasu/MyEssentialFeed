//
//  FeedSnapshotTests.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 01/02/24.
//

import XCTest
import MyEssentialFeediOS

class FeedSnapshotTests: XCTestCase {
    
    func test_emptyFeed() {
        
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        
        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
    }
    
    
    // MARK: - Helpers
    
    private func makeSUT() -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let controller = storyboard.instantiateInitialViewController() as! FeedViewController
        controller.loadViewIfNeeded()
        return controller
    }
    
    public func emptyFeed() -> [FeedImageCellController] {
        return []
    }
    

    private func record(snapshot: UIImage, named name: String, file: StaticString = #file, line: UInt = #line) {
        guard let snapshotData = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return
        }
        
        // `file` parameter holds the path to the current file
        // storing the snapshot to the same directory also allows you to add it to git and share with others
        
        let snapshotURL = URL(fileURLWithPath: String(describing: file))  // ../MyEssentialFeediOSTests/FeedSnapshotTests.swift
            .deletingLastPathComponent() // ../MyEssentialFeediOSTests
            .appendingPathComponent("snapshots") // ../MyEssentialFeediOSTests/snapshots
            .appendingPathComponent("\(name).png") // ../MyEssentialFeediOSTests/snapshots/EMPTY_FEED.png

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try snapshotData.write(to: snapshotURL)
        } catch {
            XCTFail("Failed to record snapshot with error \(error)", file: file, line: line)
        }
        
    }
}

extension UIViewController {
    func snapshot() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { action in
            view.layer.render(in: action.cgContext)
        }
    }
}
