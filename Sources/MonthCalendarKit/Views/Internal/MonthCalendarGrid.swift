//
//  MonthCalendarGrid.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// The seven-column grid of day cells. Computes the visible date
/// range, builds a ``CalendarDay`` for every cell and forwards it
/// to the host's day-cell view builder.
///
/// Tapping a cell toggles the binding passed to
/// ``MonthCalendarView/init(month:selection:showsHeader:dayCell:)``:
/// tapping the currently-selected day clears the selection,
/// tapping any other day selects it.
struct MonthCalendarGrid<DayContent: View>: View {
    let month: Date
    @Binding var selection: Date?
    let dayCell: (CalendarDay) -> DayContent

    private let calendar = Calendar.current
    private static var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
    }

    var body: some View {
        let days = CalendarMath.gridDays(for: month, calendar: calendar)
        LazyVGrid(columns: Self.columns, spacing: 2) {
            ForEach(days, id: \.self) { date in
                Button {
                    toggleSelection(of: date)
                } label: {
                    dayCell(makeDay(for: date))
                }
                .buttonStyle(.plain)
                .accessibilityLabel(accessibilityLabel(for: date))
            }
        }
    }

    // MARK: - Helpers

    private func makeDay(for date: Date) -> CalendarDay {
        CalendarDay(
            date: date,
            isCurrentMonth: calendar.isDate(
                date, equalTo: month, toGranularity: .month
            ),
            isToday: calendar.isDateInToday(date),
            isSelected: selection.map {
                calendar.isDate($0, inSameDayAs: date)
            } ?? false
        )
    }

    private func toggleSelection(of date: Date) {
        withAnimation(.spring(duration: 0.25)) {
            if let selected = selection,
               calendar.isDate(selected, inSameDayAs: date) {
                selection = nil
            } else {
                selection = date
            }
        }
    }

    private func accessibilityLabel(for date: Date) -> String {
        date.formatted(.dateTime.weekday(.wide).month(.wide).day().year())
    }
}
