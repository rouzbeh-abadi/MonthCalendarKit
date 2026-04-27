//
//  MonthCalendarHeader.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// The month-navigation row above the grid: previous-month chevron,
/// month title, "Today" jump button, next-month chevron.
///
/// Internal helper used by ``MonthCalendarView`` when its
/// `showsHeader` parameter is `true`. Hosts that want their own
/// chrome can disable the built-in header and place their own view
/// above the calendar.
struct MonthCalendarHeader: View {
    @Binding var month: Date

    @Environment(\.monthCalendarTheme) private var theme

    private let calendar = Calendar.current

    var body: some View {
        HStack {
            chevronButton(symbol: .previousMonth,
                          accessibilityLabel: "Previous month") {
                advance(by: -1)
            }

            Spacer()

            Text(month.formatted(.dateTime.month(.wide).year()))
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.textPrimary)
                .monospacedDigit()
                .accessibilityAddTraits(.isHeader)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    withAnimation(.spring(duration: 0.3)) {
                        month = Date()
                    }
                } label: {
                    Text("Today")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(theme.accent)
                        .opacity(isOnCurrentMonth ? 0.35 : 1)
                }
                .disabled(isOnCurrentMonth)
                .accessibilityLabel("Jump to today")
                .accessibilityHint(isOnCurrentMonth
                                   ? "Already on the current month"
                                   : "Jumps the calendar to today")

                chevronButton(symbol: .nextMonth,
                              accessibilityLabel: "Next month") {
                    advance(by: 1)
                }
            }
        }
        .padding(.horizontal, 4)
    }

    // MARK: - Helpers

    private var isOnCurrentMonth: Bool {
        calendar.isDate(month, equalTo: Date(), toGranularity: .month)
    }

    private func chevronButton(symbol: SystemImage,
                               accessibilityLabel: String,
                               action: @escaping () -> Void) -> some View {

        Button(action: action) {
            symbol.image
                .font(.title3.weight(.semibold))
                .foregroundStyle(theme.accent)
        }
        .accessibilityLabel(accessibilityLabel)
    }

    private func advance(by months: Int) {
        guard let next = calendar.date(byAdding: .month,
                                       value: months,
                                       to: month) else {
            return
        }
        withAnimation(.spring(duration: 0.3)) {
            month = next
        }
    }
}
