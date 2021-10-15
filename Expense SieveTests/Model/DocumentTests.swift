//
//  DocumentTests.swift
//  Expense SieveTests
//
//  Created by John Solsma on 10/15/21.
//  Copyright © 2021 Big Nerd Ranch. All rights reserved.
//

@testable import Expense_Sieve
import XCTest

class DocumentTests: XCTestCase {

    let identifier = UUID().uuidString
    let docDirectory: URL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    let directoryPathModifier = DocumentStore.DirectoryPathModifier.test
    lazy var docURL = docDirectory.appendingPathComponent("\(identifier)." + directoryPathModifier.rawValue)
    lazy var document = Document(fileURL: docURL, pathModifier: directoryPathModifier)

    func testingImage() -> UIImage {
        let rect = CGRect(origin: .zero, size: .init(width: 10, height: 10))
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }

    override func setUpWithError() throws {
        document.set(testingImage(), forKey: identifier)
    }

    override func tearDownWithError() throws {
        document.set(nil, forKey: identifier)
    }

    func testFetchImage() throws {
        XCTAssertNotNil(document.image(forKey: identifier))
    }

    func testSetImage() throws {
        document.set(nil, forKey: identifier)
        document.set(testingImage(), forKey: identifier)
        XCTAssertNotNil(document.image(forKey: identifier))
    }
}
