//
//  DocumentStore.swift
//  Expense Sieve
//
//  Created by Michael Ward on 8/31/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import Foundation

class DocumentStore {

    enum DirectoryPathModifier: String {
        case sieve
        case test
    }

    // MARK: - Properties

    private let docDirectory: URL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    private var ioQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    private var documentURLs: [String:URL] = [:]
    private var directoryPathModifier: DirectoryPathModifier

    // MARK: - Initialization

    init(for directoryPathModifier: DirectoryPathModifier = .sieve) {
        self.directoryPathModifier = directoryPathModifier
    }

    // MARK: - Managing Documents
    
    func createDocument(completion: @escaping (Document)->Void) {
        // Create a new document
        let identifier = UUID().uuidString
        let docURL = docDirectory.appendingPathComponent("\(identifier)." + directoryPathModifier.rawValue)
        let doc = Document(fileURL: docURL, pathModifier: directoryPathModifier)
        
        // Give the newly-created document an on-disk representation
        doc.save(to: docURL, for: .forCreating) {[unowned self] success in
            assert(success, "Failed to create new document at \(docURL)")
            self.documentURLs[doc.report.identifier] = docURL
            completion(doc)
        }
    }
    
    func document(forIdentifier identifier: String) -> Document? {
        guard let docURL = documentURLs[identifier],
              FileManager.default.fileExists(atPath: docURL.path) else { return nil }

        let doc = Document(fileURL: docURL, pathModifier: directoryPathModifier)
        return doc
    }
    
    func loadSummaries(completion: @escaping ([Report.Summary])->Void) {
        ioQueue.addOperation { [unowned self] in
            var summaries: [Report.Summary] = []
            var foundDocumentURLs: [String:URL] = [:]
            defer { // Make sure we don't return without calling the completion
                OperationQueue.main.addOperation {
                    self.documentURLs = foundDocumentURLs
                    completion(summaries)
                }
            }
            
            // Fetch a list of all the files in the app's Documents directory
            guard let urls: [URL] =
                try? FileManager.default.contentsOfDirectory(at: self.docDirectory,
                                                             includingPropertiesForKeys: [],
                                                             options: []) else { return }
            
            // Generate a new array of summaries from the reports on disk
            for url in urls {
                guard directoryPathModifier.rawValue == url.pathExtension else { continue }
                // step into the .sieve directory and get the report archive there
                let reportURL = url.appendingPathComponent(Document.reportFileName(for: directoryPathModifier))
                let decoder = JSONDecoder()
                if let reportData = try? NSData(contentsOf: reportURL) as Data,
                    let report = try? decoder.decode(Report.self, from: reportData) {
                    foundDocumentURLs[report.identifier] = url
                    summaries.append(report.summary)
                }
            }
        }
    }

}
