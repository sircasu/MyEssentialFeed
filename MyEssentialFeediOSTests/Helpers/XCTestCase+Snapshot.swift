//
//  XCTestCase+Snapshot.swift
//  MyEssentialFeediOSTests
//
//  Created by Matteo Casu on 14/02/24.
//

import XCTest

extension XCTestCase {
    
    public func assert(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        
        guard let storedSnapshotData = try? Data(contentsOf: snapshotURL) else {
            
            XCTFail("Failed to load stored snapshot at URL \(snapshotURL). Use the `record` method to store a snapshot before asserting", file: file, line: line)
            return
        }
        
        if snapshotData != storedSnapshotData {
            
            let temporarySnapshotURL = URL(
                fileURLWithPath: NSTemporaryDirectory(),
                isDirectory: true
            ).appendingPathComponent (snapshotURL.lastPathComponent)
            
            
            try? snapshotData? .write(to: temporarySnapshotURL)
            
            XCTFail("New snapshot does not match stored snapshot. New snapshot URL: \(temporarySnapshotURL), Stored snapshot URL: \(snapshotURL)", file: file, line: line)
        }
    }



    public func record(snapshot: UIImage, named name: String, file: StaticString = #filePath, line: UInt = #line) {
        let snapshotURL = makeSnapshotURL(named: name, file: file)
        let snapshotData = makeSnapshotData(for: snapshot, file: file, line: line)

        do {
            try FileManager.default.createDirectory(
                at: snapshotURL.deletingLastPathComponent(),
                withIntermediateDirectories: true
            )
            try snapshotData?.write(to: snapshotURL)
            // `record` generate a failure to reminde us that we need to revert to the `assert` function before proceed (a commit for example)
            XCTFail("Record succeeded - use `assert` to compare that snapshot from now on.", file: file, line: line)

        } catch {
            XCTFail("Failed to record snapshot with error \(error)", file: file, line: line)
        }
        
    }





    private func makeSnapshotURL(named name: String, file: StaticString) -> URL {
        
        
        // `file` parameter holds the path to the current file
        // storing the snapshot to the same directory also allows you to add it to git and share with others

        return URL(fileURLWithPath: String(describing: file))  // ../MyEssentialFeediOSTests/FeedSnapshotTests.swift
            .deletingLastPathComponent() // ../MyEssentialFeediOSTests
            .appendingPathComponent("snapshots") // ../MyEssentialFeediOSTests/snapshots
            .appendingPathComponent("\(name).png") // ../MyEssentialFeediOSTests/snapshots/EMPTY_FEED.png

    }


    private func makeSnapshotData(for snapshot: UIImage, file: StaticString = #filePath, line: UInt = #line) -> Data? {
        
        guard let data = snapshot.pngData() else {
            XCTFail("Failed to generate PNG data representation from snapshot", file: file, line: line)
            return nil
        }
        
        return data
    }

}
