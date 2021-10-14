//
//  Expense.swift
//  Expense Sieve
//
//  Created by Michael Ward on 7/7/16.
//  Copyright © 2016 Big Nerd Ranch. All rights reserved.
//

import Foundation

class Expense: Codable {
    
    fileprivate(set) var photoKey: String = UUID().uuidString
    var amount = 0.0
    var vendor: String?
    var comment: String?
    var date = Date()

    init(photoKey: String = UUID().uuidString,
         amount: Double = 0.0,
         vendor: String? = nil,
         comment: String? = nil,
         date: Date = Date()) {
        self.photoKey = photoKey
        self.amount = amount
        self.vendor = vendor
        self.comment = comment
        self.date = date
    }

}
