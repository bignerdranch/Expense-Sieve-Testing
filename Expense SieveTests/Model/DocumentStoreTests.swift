//
//  DocumentStoreTests.swift
//  Expense SieveTests
//
//  Created by John Solsma on 10/14/21.
//  Copyright © 2021 Big Nerd Ranch. All rights reserved.
//

@testable import Expense_Sieve
import XCTest

class DocumentStoreTests: XCTestCase {

    let documentStore = DocumentStore(for: .test)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testReadSummaries() throws {
        documentStore.loadSummaries { (summaries) in
            dump(summaries)
        }
    }

    func testCreateDocument() throws {
        let exp = expectation(description: "Creating a document")
        documentStore.createDocument(completion: { _ in
            exp.fulfill()
        })
        waitForExpectations(timeout: 3)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
