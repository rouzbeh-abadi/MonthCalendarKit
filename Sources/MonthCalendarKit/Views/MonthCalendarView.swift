//
//  MonthCalendarView.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// A fully-themed monthly calendar grid built from SwiftUI primitives.
///
/// `MonthCalendarView` renders a navigable, paged month-by-month
/// grid where every visible cell is built by the host app — so any
/// per-day decoration (status dots, badges, photos, custom shapes)
/// can be displayed.
///
/// ## Usage
///
/// Minimal example using the bundled ``PlainDayCell``:
///
/// ```swift
/// struct MyCalendar: View {
///     @State private var month = Date()
///     @State private var selection: Date? = Date()
///
///     var body: some View {
///         MonthCalendarView(month: $month, selection: $selection) { day in
///             PlainDayCell(day: day)
///         }
///     }
/// }
/// ```
///
/// To surface per-day status the way a tracking app might, swap in
/// ``DotIndicatorDayCell`` and compute the indicator colors from
/// your own data:
///
/// ```swift
/// MonthCalendarView(month: $month, selection: $selection) { day in
///     DotIndicatorDayCell(day: day, dots: dotsForDay(day.date))
/// }
/// ```
///
/// To match an existing design system, conform a value type to
/// ``MonthCalendarTheme`` and inject it via the environment:
///
/// ```swift
/// MonthCalendarView(...)
///     .environment(\.monthCalendarTheme, MyAppCalendarTheme())
/// ```
///
/// ## Behaviour
///
/// - The grid always renders complete weeks. Padding cells from the
///   previous and next months are passed to your day-cell builder
///   with ``CalendarDay/isCurrentMonth`` set to `false`, so you can
///   dim them.
/// - Tapping the currently-selected day clears the selection;
///   tapping any other day selects it. Selection is exposed through
///   the `selection` binding.
/// - Horizontally swiping the grid advances or rewinds by one
///   month; the built-in header chevrons do the same thing.
/// - The "Today" jump button auto-disables when the displayed
///   month already contains today.
/// - The displayed month follows `Calendar.current` for first-weekday
///   ordering, time zone, and short weekday symbols.
public struct MonthCalendarView<DayContent: View>: View {
    @Binding private var month: Date
    @Binding private var selection: Date?
    private let showsHeader: Bool
    private let dayCell: (CalendarDay) -> DayContent

    /// Creates a new calendar.
    ///
    /// - Parameters:
    ///   - month: A binding to the currently displayed month. Only
    ///     the `year` and `month` components are read; the day is
    ///     ignored. Mutating this binding (e.g. through the built-in
    ///     header buttons or a horizontal swipe) animates the grid
    ///     to the new month.
    ///   - selection: A binding to the currently selected day, or
    ///     `nil` if no day is selected. Tapping a day mutates this.
    ///   - showsHeader: Whether to render the built-in month
    ///     navigation header. Defaults to `true`. Pass `false` to
    ///     supply your own chrome.
    ///   - dayCell: A view builder that produces the cell for every
    ///     visible day, including padding days from adjacent months.
    public init(month: Binding<Date>,
                selection: Binding<Date?>,
                showsHeader: Bool = true,
                @ViewBuilder dayCell: @escaping (CalendarDay) -> DayContent) {

        self._month = month
        self._selection = selection
        self.showsHeader = showsHeader
        self.dayCell = dayCell
    }

    public var body: some View {
        VStack(spacing: 12) {
            if showsHeader {
                MonthCalendarHeader(month: $month)
            }
            MonthCalendarWeekdayHeader()
            MonthCalendarGrid(month: month,
                              selection: $selection,
                              dayCell: dayCell)
            // Simultaneous (rather than `.gesture`) so the horizontal
            // swipe doesn't pre-empt the day-cell button taps. The
            // gesture only fires after a 30pt drag, so a quick tap
            // on a cell never triggers it.
            .simultaneousGesture(monthSwipeGesture)
        }
    }

    // MARK: - Swipe gesture

    /// Horizontal swipe gesture that pages the month one step
    /// forward or backward. Vertical movement and stationary taps
    /// pass through to the underlying day buttons.
    private var monthSwipeGesture: some Gesture {
        DragGesture(minimumDistance: 30)
            .onEnded { value in
                let horizontal = value.translation.width
                let vertical = value.translation.height
                // Treat the gesture as a swipe only when it is
                // primarily horizontal — otherwise it can fight
                // with the parent ScrollView's vertical scroll.
                guard abs(horizontal) > abs(vertical) else { return }
                let calendar = Calendar.current
                let direction = horizontal < 0 ? 1 : -1
                guard let next = calendar.date(byAdding: .month,
                                               value: direction,
                                               to: month) else { return }
                withAnimation(.spring(duration: 0.3)) {
                    month = next
                }
            }
    }
}
