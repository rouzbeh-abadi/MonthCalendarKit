//
//  DotIndicatorDayCell.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// A day cell that renders the day number with up to three small
/// status dots underneath.
///
/// Useful for surfacing "items per day" information at a glance:
/// completed events vs. pending vs. failed, dose status, journal
/// entries by category, and so on. The host computes the dot
/// colours; the cell only renders them.
///
/// Example:
///
/// ```swift
/// MonthCalendarView(month: $month, selection: $selection) { day in
///     DotIndicatorDayCell(
///         day: day,
///         dots: dotsForDay(day.date),
///         highlighted: hasContent(on: day.date)
///     )
/// }
/// ```
///
/// At most three dots are rendered, even if more are passed in;
/// callers should sort their array so the most important indicator
/// always appears.
public struct DotIndicatorDayCell: View {

    /// The maximum number of dots rendered under a day. Extra dots
    /// passed in `dots` are ignored.
    public static let maxDots: Int = 3

    private let day: CalendarDay
    private let dots: [Color]
    private let highlighted: Bool

    @Environment(\.monthCalendarTheme) private var theme

    /// Creates a day cell with status indicator dots.
    ///
    /// - Parameters:
    ///   - day: The day descriptor passed in by
    ///     ``MonthCalendarView`` for this cell.
    ///   - dots: Colors of the indicator dots to render under the
    ///     day number, in display order. Pass an empty array for
    ///     no dots. Only the first ``maxDots`` are rendered.
    ///   - highlighted: When `true` and the day is in the current
    ///     month, paints the cell background with the theme's
    ///     `dayHighlight` color (a softer "this day matters" cue,
    ///     distinct from selection). Defaults to `false`.
    public init(day: CalendarDay,
                dots: [Color] = [],
                highlighted: Bool = false) {

        self.day = day
        self.dots = dots
        self.highlighted = highlighted
    }

    public var body: some View {
        VStack(spacing: 4) {
            Text("\(Calendar.current.component(.day, from: day.date))")
                .font(.subheadline.weight(day.isToday ? .bold : .regular))
                .foregroundStyle(textColor)
                .monospacedDigit()

            if !dots.isEmpty {
                HStack(spacing: 2) {
                    ForEach(Array(dots.prefix(Self.maxDots).enumerated()),
                            id: \.offset) { _, color in
                        Circle()
                            .fill(color)
                            .frame(width: 5, height: 5)
                    }
                }
            } else {
                // Reserve the dot row's height so day numbers sit on
                // the same baseline whether dots are present or not.
                Spacer().frame(height: 5)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 48)
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
        if day.isSelected { return theme.accentSoft }
        if highlighted && day.isCurrentMonth { return theme.dayHighlight }
        return .clear
    }
}
