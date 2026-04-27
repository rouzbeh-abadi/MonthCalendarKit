//
//  CalendarDay.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import Foundation

/// A description of a single day cell rendered by ``MonthCalendarView``.
///
/// `MonthCalendarView` constructs one `CalendarDay` for every cell in
/// the visible grid — including padding cells from the previous and
/// next months — and passes it to the consumer's day-cell builder.
/// Use the contextual flags (``isCurrentMonth``, ``isToday``,
/// ``isSelected``) to decide how to style the cell.
public struct CalendarDay: Hashable, Identifiable, Sendable {
    /// The start-of-day `Date` represented by this cell.
    public let date: Date

    /// `true` when ``date`` falls in the month the calendar is
    /// currently displaying. Padding cells from the previous and
    /// next months are passed with `isCurrentMonth == false` so they
    /// can be visually de-emphasised.
    public let isCurrentMonth: Bool

    /// `true` when ``date`` is today in the calendar's current
    /// time zone.
    public let isToday: Bool

    /// `true` when ``date`` matches the selection binding passed to
    /// ``MonthCalendarView``.
    public let isSelected: Bool

    /// Stable identifier for `Identifiable` conformance. Each visible
    /// cell has a distinct start-of-day `Date`, so the date itself
    /// is a sufficient identifier.
    public var id: Date { date }

    /// Creates a new day descriptor.
    ///
    /// In normal usage, ``MonthCalendarView`` constructs these for
    /// you; the initialiser is public so tests and previews can
    /// fabricate values without rendering a full calendar.
    ///
    /// - Parameters:
    ///   - date: The start-of-day `Date` represented by this cell.
    ///   - isCurrentMonth: Whether the date belongs to the displayed
    ///     month or to a leading/trailing padding cell.
    ///   - isToday: Whether the date is today in the active calendar.
    ///   - isSelected: Whether the date matches the selection.
    public init(date: Date,
                isCurrentMonth: Bool,
                isToday: Bool,
                isSelected: Bool) {

        self.date = date
        self.isCurrentMonth = isCurrentMonth
        self.isToday = isToday
        self.isSelected = isSelected
    }
}
