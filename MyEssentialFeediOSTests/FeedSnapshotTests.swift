//
//  FeedSnapshotTests.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 01/02/24.
//

import XCTest
import MyEssentialFeediOS
@testable import MyEssentialFeed
 
class FeedSnapshotTests: XCTestCase {
    
    func test_emptyFeed() {
        
        let sut = makeSUT()
        
        sut.display(emptyFeed())
        
        
        record(snapshot: sut.snapshot(), named: "EMPTY_FEED")
    }
    
    
    func test_feedWithContent() {
        let sut = makeSUT()
        
        sut.display(feedWithContent())
        
        record(snapshot: sut.snapshot(), named: "FEED_WITH_CONTENT")
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
    
    private func feedWithContent() -> [ImageStub] {
            return [
                ImageStub(
                    description: "The East Side Gallery is an open-air gallery in Berlin. It consists of a series of murals painted directly on a 1,316 m long remnant of the Berlin Wall, located near the centre of Berlin, on Mühlenstraße in Friedrichshain-Kreuzberg. The gallery has official status as a Denkmal, or heritage-protected landmark.",
                    location: "East Side Gallery\nMemorial in Berlin, Germany",
                    image: UIImage.make(withColor: .red)
                ),
                ImageStub(
                    description: "Garth Pier is a Grade II listed structure in Bangor, Gwynedd, North Wales.",
                    location: "Garth Pier",
                    image: UIImage.make(withColor: .green)
                )
            ]
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


private extension FeedViewController {
    func display(_ stubs: [ImageStub]) {
        
        let cells: [FeedImageCellController] = stubs.map { stub in
            let cellController = FeedImageCellController(delegate: stub)
            stub.controller = cellController
            return cellController
        }
        
        display(cells)
    }
}


private class ImageStub: FeedImageCellControllerDelegate {
    let viewModel: FeedImageViewModel<UIImage>
    
    // since the controller has a strong reference to the delegate,
    // we need to make the image stub reference to the controller weak,
    // to avoid retain cycle
    weak var controller: FeedImageCellController?
    
    
    init(description: String?, location: String?, image: UIImage?) {
        viewModel = FeedImageViewModel(
            description: description,
            location: location,
            image: image,
            isLoading: false,
            shouldRetry: image == nil)
    }
    
    func didRequestImage() {
        controller?.display(viewModel)
    }
    
    func didCancelImageRequest() {
        
    }
    

    
}
