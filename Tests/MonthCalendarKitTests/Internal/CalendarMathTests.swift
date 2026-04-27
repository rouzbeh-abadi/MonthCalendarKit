//
//  CalendarMathTests.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import XCTest
@testable import MonthCalendarKit

final class CalendarMathTests: XCTestCase {

    // MARK: - Fixtures

    /// Stable Gregorian/UTC calendar with Sunday as the first
    /// weekday. Used so test results don't depend on the host
    /// machine's locale or time zone.
    private var sundayFirstUTC: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.firstWeekday = 1
        return calendar
    }

    /// Same as ``sundayFirstUTC`` but starting on Monday — the
    /// convention used in most of Europe.
    private var mondayFirstUTC: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        calendar.firstWeekday = 2
        return calendar
    }

    private func date(_ year: Int, _ month: Int, _ day: Int, calendar: Calendar) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return calendar.date(from: components)!
    }

    // MARK: - Cell count

    func testGridDays_alwaysReturnsCompleteWeeks() {
        let calendar = sundayFirstUTC
        for month in 1...12 {
            let anchor = date(2026, month, 1, calendar: calendar)
            let days = CalendarMath.gridDays(for: anchor, calendar: calendar)
            XCTAssertEqual(
                days.count % 7, 0,
                "Month \(month) returned \(days.count) cells; not a multiple of 7"
            )
            XCTAssertGreaterThanOrEqual(days.count, 28)
            XCTAssertLessThanOrEqual(days.count, 42)
        }
    }

    func testGridDays_acceptsAnyDateWithinTheMonth() {
        // Passing day 1, day 15 or day 28 of the same month must
        // produce identical grids — only year/month are read.
        let calendar = sundayFirstUTC
        let first = CalendarMath.gridDays(
            for: date(2026, 6, 1, calendar: calendar), calendar: calendar
        )
        let mid = CalendarMath.gridDays(
            for: date(2026, 6, 15, calendar: calendar), calendar: calendar
        )
        let last = CalendarMath.gridDays(
            for: date(2026, 6, 28, calendar: calendar), calendar: calendar
        )
        XCTAssertEqual(first, mid)
        XCTAssertEqual(first, last)
    }

    // MARK: - Leading days

    func testGridDays_sundayFirstLeadingPaddingFromPreviousMonth() {
        // April 2026 starts on a Wednesday. With Sunday-first that
        // means three leading days from March (Sun 29, Mon 30, Tue 31).
        let calendar = sundayFirstUTC
        let april = date(2026, 4, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: april, calendar: calendar)

        let firstThree = days.prefix(3).map { calendar.component(.day, from: $0) }
        XCTAssertEqual(firstThree, [29, 30, 31])
        XCTAssertEqual(calendar.component(.month, from: days.first!), 3)
        XCTAssertEqual(calendar.component(.day, from: days[3]), 1)
        XCTAssertEqual(calendar.component(.month, from: days[3]), 4)
    }

    func testGridDays_mondayFirstReducesLeadingPadding() {
        // Same April 2026 but Monday-first: only two leading days
        // (Mon 30, Tue 31).
        let calendar = mondayFirstUTC
        let april = date(2026, 4, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: april, calendar: calendar)

        let firstTwo = days.prefix(2).map { calendar.component(.day, from: $0) }
        XCTAssertEqual(firstTwo, [30, 31])
        XCTAssertEqual(calendar.component(.day, from: days[2]), 1)
        XCTAssertEqual(calendar.component(.month, from: days[2]), 4)
    }

    func testGridDays_noLeadingPaddingWhenMonthStartsOnFirstWeekday() {
        // November 2026 starts on a Sunday in Sunday-first.
        let calendar = sundayFirstUTC
        let nov = date(2026, 11, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: nov, calendar: calendar)
        XCTAssertEqual(calendar.component(.day, from: days.first!), 1)
        XCTAssertEqual(calendar.component(.month, from: days.first!), 11)
    }

    // MARK: - Trailing padding

    func testGridDays_padsTrailingFromNextMonth() {
        // April 2026 has 30 days, starts Wed in Sunday-first → 3
        // leading + 30 = 33 → pad to 35 → 2 trailing days.
        let calendar = sundayFirstUTC
        let april = date(2026, 4, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: april, calendar: calendar)

        XCTAssertEqual(days.count, 35)
        let lastTwo = days.suffix(2).map { calendar.component(.day, from: $0) }
        XCTAssertEqual(lastTwo, [1, 2])
        XCTAssertEqual(calendar.component(.month, from: days[33]), 5)
    }

    // MARK: - Year boundaries

    func testGridDays_januaryWrapsBackIntoPreviousDecember() {
        // Jan 1 2026 is a Thursday. Sunday-first → 4 leading days
        // from Dec 2025 (Sun 28 — Wed 31).
        let calendar = sundayFirstUTC
        let jan = date(2026, 1, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: jan, calendar: calendar)
        let first = days.first!
        XCTAssertEqual(calendar.component(.year, from: first), 2025)
        XCTAssertEqual(calendar.component(.month, from: first), 12)
        XCTAssertEqual(calendar.component(.day, from: first), 28)
    }

    func testGridDays_decemberWrapsForwardIntoNextJanuary() {
        let calendar = sundayFirstUTC
        let dec = date(2026, 12, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: dec, calendar: calendar)
        let last = days.last!
        XCTAssertEqual(calendar.component(.year, from: last), 2027)
        XCTAssertEqual(calendar.component(.month, from: last), 1)
    }

    // MARK: - February (leap year coverage)

    func testGridDays_february2024ContainsAll29DaysOfALeapMonth() {
        let calendar = sundayFirstUTC
        let feb = date(2024, 2, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: feb, calendar: calendar)
        let februaryDays = days
            .filter { calendar.component(.month, from: $0) == 2 }
            .map { calendar.component(.day, from: $0) }
        XCTAssertEqual(februaryDays, Array(1...29))
    }

    func testGridDays_february2025ContainsAll28DaysOfANonLeapMonth() {
        let calendar = sundayFirstUTC
        let feb = date(2025, 2, 15, calendar: calendar)
        let days = CalendarMath.gridDays(for: feb, calendar: calendar)
        let februaryDays = days
            .filter { calendar.component(.month, from: $0) == 2 }
            .map { calendar.component(.day, from: $0) }
        XCTAssertEqual(februaryDays, Array(1...28))
    }

    // MARK: - Determinism

    func testGridDays_sameInputProducesSameOutput() {
        let calendar = sundayFirstUTC
        let anchor = date(2026, 6, 15, calendar: calendar)
        let a = CalendarMath.gridDays(for: anchor, calendar: calendar)
        let b = CalendarMath.gridDays(for: anchor, calendar: calendar)
        XCTAssertEqual(a, b)
    }

    // MARK: - Weekday symbol ordering

    func testOrderedWeekdaySymbols_sundayFirstReturnsUnchanged() {
        let calendar = sundayFirstUTC
        let symbols = CalendarMath.orderedShortWeekdaySymbols(calendar: calendar)
        XCTAssertEqual(symbols, calendar.shortWeekdaySymbols)
    }

    func testOrderedWeekdaySymbols_mondayFirstStartsWithMonday() {
        let calendar = mondayFirstUTC
        let symbols = CalendarMath.orderedShortWeekdaySymbols(calendar: calendar)
        // The Sun-first array is rotated by 1, so what was at
        // index 1 (Mon) is now at index 0 and Sunday wraps to
        // the end.
        XCTAssertEqual(symbols.first, calendar.shortWeekdaySymbols[1])
        XCTAssertEqual(symbols.last, calendar.shortWeekdaySymbols[0])
        XCTAssertEqual(symbols.count, 7)
    }
}
