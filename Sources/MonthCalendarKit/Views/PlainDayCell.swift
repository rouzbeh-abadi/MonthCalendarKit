//
//  PlainDayCell.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// A minimal day cell that shows just the day number, with the
/// today border and the selected fill applied automatically from
/// the active ``MonthCalendarTheme``.
///
/// Use when you don't need any per-day decoration:
///
/// ```swift
/// MonthCalendarView(month: $month, selection: $selection) { day in
///     PlainDayCell(day: day)
/// }
/// ```
public struct PlainDayCell: View {
    private let day: CalendarDay

    @Environment(\.monthCalendarTheme) private var theme

    /// Creates a plain day cell.
    ///
    /// - Parameter day: The day descriptor passed in by
    ///   ``MonthCalendarView`` for this cell.
    public init(day: CalendarDay) {
        self.day = day
    }

    public var body: some View {
        Text("\(Calendar.current.component(.day, from: day.date))")
            .font(.subheadline.weight(day.isToday ? .bold : .regular))
            .foregroundStyle(textColor)
            .monospacedDigit()
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(day.isToday ? theme.accent : .clear, lineWidth: 1.5)
            )
    }

    // MARK: - Styling

    private var textColor: Color {
        if !day.isCurrentMonth { return theme.textSecondary.opacity(0.3) }
        if day.isSelected || day.isToday { return theme.accent }
        return theme.textPrimary
    }

    private var backgroundColor: Color {
        day.isSelected ? theme.accentSoft : .clear
    }
}
