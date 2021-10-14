//
//  ReportTests.swift
//  Expense SieveTests
//
//  Created by John Solsma on 10/14/21.
//  Copyright © 2021 Big Nerd Ranch. All rights reserved.
//

@testable import Expense_Sieve
import XCTest

class ReportTests: XCTestCase {

    func testNoExpenses() throws {
        let emptyReport = Report()
        XCTAssert(emptyReport.expenseTotal == 0)
    }

    func testExpenseCalculation() throws {
        let expenses: [Expense] = [Expense(amount: 7.0), Expense(amount: 7.0), Expense(amount: 7.0)]
        let report = Report(expenses: expenses)
        let expected = expenses.map({$0.amount}).reduce(0.0,+)
        let actual = report.expenseTotal
        XCTAssert(expected == actual)
    }

    func testAddingExpense() throws {
        var report = Report(expenses: [Expense(amount: 7.0), Expense(amount: 7.0), Expense(amount: 7.0)])
        XCTAssertEqual(report.expenseTotal, 21.0)
        report.expenses.append(Expense(amount: 7.0))
        XCTAssertEqual(report.expenseTotal, 28.0)
    }

    func testSummaryGeneration() throws {
        let report = Report(title: "SummaryTest", expenses: [Expense(amount: 7.0), Expense(amount: 7.0), Expense(amount: 7.0)])
        let expected: Report.Summary = .init(identifier: report.identifier, title: "SummaryTest", expenseTotal: 21.0)
        let actual = report.summary
        XCTAssertEqual(expected.identifier, actual.identifier)
        XCTAssertEqual(expected.title, actual.title)
        XCTAssertEqual(expected.expenseTotal, actual.expenseTotal)

    }
}
