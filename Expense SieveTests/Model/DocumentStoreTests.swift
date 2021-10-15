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
    var summaries: [Report.Summary] = []

    override func setUpWithError() throws {
        let exp = expectation(description: "Creating an initial document")
        documentStore.createDocument { [weak self] _ in
            guard let self = self else { return }
            self.documentStore.loadSummaries { [weak self] summaries in
                guard let self = self else { return }
                self.summaries = summaries
                exp.fulfill()
            }
        }
        waitForExpectations(timeout: 3)
    }

    override func tearDownWithError() throws {
        documentStore.clearAllTestDocuments()
    }

    func testDocumnetForIdentifier() throws {
        guard let summary = summaries.first else {
            XCTFail("Summaries not loaded in setup.")
            return
        }
        let document = documentStore.document(forIdentifier: summary.identifier)
        XCTAssertNotNil(document)
    }

    func testReadSummaries() throws {
        let exp = expectation(description: "Reading a document")
        documentStore.loadSummaries { summaries in
            XCTAssertEqual(summaries.count, 1)
            exp.fulfill()
        }
        waitForExpectations(timeout: 3)
    }

    func testCreateDocument() throws {
        let exp = expectation(description: "Creating a document")
        documentStore.createDocument(completion: { _ in
            exp.fulfill()
        })
        waitForExpectations(timeout: 3)
    }

}

extension DocumentStore {

    func clearAllTestDocuments() {
        let fileManager = FileManager.default
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentsPath = docURL.path
        do {
            let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentsPath)")
            for fileName in fileNames {
                if (fileName.hasSuffix("." + DirectoryPathModifier.test.rawValue)) {
                    let filePathName = "\(documentsPath)/\(fileName)"
                    try fileManager.removeItem(atPath: filePathName)
                }
            }
        } catch {
            print("Could not clear test files: \(error)")
        }
    }

}
