//
//  XCTestCase+MemoryLeakTracking.swift
//  EssentialAppTests
//
//  Created by Matteo Casu on 21/01/24.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
}


