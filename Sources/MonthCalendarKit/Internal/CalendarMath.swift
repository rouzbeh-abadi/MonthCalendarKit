//
//  CalendarMath.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import Foundation

/// Pure date helpers used by the month grid.
///
/// Kept as a stateless namespace so it's trivially testable
/// without a SwiftUI runtime.
enum CalendarMath {

    /// Returns the visible cells for the month containing `month`.
    ///
    /// The returned array always represents complete weeks. It
    /// starts with leading days from the previous month if the
    /// first of the month doesn't fall on the calendar's first
    /// weekday, and pads with days from the next month so the
    /// array length is always a multiple of seven.
    ///
    /// - Parameters:
    ///   - month: Any date inside the month to render. Only the
    ///     `year` and `month` components are read.
    ///   - calendar: The `Calendar` to use for the math. Pass
    ///     `Calendar.current` in production; tests typically
    ///     construct one with a fixed time zone and `firstWeekday`
    ///     so results don't depend on the host machine's locale.
    /// - Returns: Start-of-day `Date`s for every cell in display
    ///   order (top-left to bottom-right, row-major).
    static func gridDays(for month: Date, calendar: Calendar) -> [Date] {
        guard
            let firstOfMonth = calendar.date(
                from: calendar.dateComponents([.year, .month], from: month)
            ),
            let monthRange = calendar.range(of: .day, in: .month, for: firstOfMonth)
        else {
            return []
        }

        let firstWeekday = calendar.component(.weekday, from: firstOfMonth)
        let leadingDays = (firstWeekday - calendar.firstWeekday + 7) % 7

        guard let startDate = calendar.date(
            byAdding: .day, value: -leadingDays, to: firstOfMonth
        ) else {
            return []
        }

        let totalDays = leadingDays + monthRange.count
        let trailing = (7 - totalDays % 7) % 7
        let totalCells = totalDays + trailing

        return (0..<totalCells).compactMap { offset in
            calendar.date(byAdding: .day, value: offset, to: startDate)
        }
    }

    /// Returns `Calendar.current.shortWeekdaySymbols` rotated so the
    /// element at index zero matches `Calendar.current.firstWeekday`.
    ///
    /// Apple's `shortWeekdaySymbols` is always Sun-first regardless
    /// of locale; this helper rotates it so it lines up with grids
    /// that respect `firstWeekday` (e.g. Monday-first in most of
    /// Europe).
    static func orderedShortWeekdaySymbols(calendar: Calendar) -> [String] {
        let symbols = calendar.shortWeekdaySymbols
        let offset = calendar.firstWeekday - 1
        guard offset > 0, offset < symbols.count else { return symbols }
        return Array(symbols[offset...] + symbols[..<offset])
    }
}
