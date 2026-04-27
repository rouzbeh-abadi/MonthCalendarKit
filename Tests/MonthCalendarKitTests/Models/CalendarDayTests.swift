//
//  CalendarDayTests.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import XCTest
@testable import MonthCalendarKit

final class CalendarDayTests: XCTestCase {

    // MARK: - Identifiable

    func testID_equalsDate() {
        let date = Date(timeIntervalSince1970: 1_745_558_400)
        let day = CalendarDay(
            date: date,
            isCurrentMonth: true,
            isToday: false,
            isSelected: false
        )
        XCTAssertEqual(day.id, date)
    }

    // MARK: - Equatable / Hashable

    func testEquality_sameValuesAreEqual() {
        let date = Date(timeIntervalSince1970: 1_745_558_400)
        let a = CalendarDay(date: date, isCurrentMonth: true, isToday: false, isSelected: false)
        let b = CalendarDay(date: date, isCurrentMonth: true, isToday: false, isSelected: false)
        XCTAssertEqual(a, b)
        XCTAssertEqual(a.hashValue, b.hashValue)
    }

    func testEquality_differentSelectionStateIsNotEqual() {
        let date = Date(timeIntervalSince1970: 1_745_558_400)
        let selected = CalendarDay(date: date, isCurrentMonth: true, isToday: false, isSelected: true)
        let unselected = CalendarDay(date: date, isCurrentMonth: true, isToday: false, isSelected: false)
        XCTAssertNotEqual(selected, unselected)
    }

    func testEquality_differentDatesAreNotEqual() {
        let earlier = Date(timeIntervalSince1970: 1_745_558_400)
        let later = Date(timeIntervalSince1970: 1_745_644_800)
        let a = CalendarDay(date: earlier, isCurrentMonth: true, isToday: false, isSelected: false)
        let b = CalendarDay(date: later,   isCurrentMonth: true, isToday: false, isSelected: false)
        XCTAssertNotEqual(a, b)
    }

    // MARK: - Property propagation

    func testInit_storesAllPropertiesVerbatim() {
        let date = Date(timeIntervalSince1970: 1_745_558_400)
        let day = CalendarDay(
            date: date,
            isCurrentMonth: false,
            isToday: true,
            isSelected: true
        )
        XCTAssertEqual(day.date, date)
        XCTAssertFalse(day.isCurrentMonth)
        XCTAssertTrue(day.isToday)
        XCTAssertTrue(day.isSelected)
    }
}
