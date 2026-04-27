//
//  MonthCalendarWeekdayHeader.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// The single row of localised short weekday symbols (Sun, Mon, ...)
/// shown above the grid. Honours `Calendar.current.firstWeekday` so
/// the labels line up with the grid columns.
struct MonthCalendarWeekdayHeader: View {
    @Environment(\.monthCalendarTheme) private var theme

    private static let columns = Array(
        repeating: GridItem(.flexible(), spacing: 2),
        count: 7
    )

    var body: some View {
        let symbols = CalendarMath.orderedShortWeekdaySymbols(
            calendar: Calendar.current
        )
        LazyVGrid(columns: Self.columns, spacing: 2) {
            ForEach(symbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(theme.textSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
        .accessibilityHidden(true)
    }
}
