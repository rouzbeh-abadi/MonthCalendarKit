//
//  MonthCalendarTheme.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// Color palette used by ``MonthCalendarView`` and the built-in day
/// cells (``PlainDayCell``, ``DotIndicatorDayCell``).
///
/// Adopt this protocol with your design system's colors, then inject
/// it into the view tree:
///
/// ```swift
/// MonthCalendarView(month: $month, selection: $selection) { day in
///     PlainDayCell(day: day)
/// }
/// .environment(\.monthCalendarTheme, MyAppCalendarTheme())
/// ```
///
/// If no theme is injected, ``DefaultMonthCalendarTheme`` (system
/// colors) is used.
public protocol MonthCalendarTheme: Sendable {
    /// Tint of the navigation chevrons, the "Today" jump button,
    /// the today-highlight border, and the selected-day text.
    var accent: Color { get }

    /// Soft accent fill painted behind the selected day.
    var accentSoft: Color { get }

    /// Background fill applied behind days marked as "highlighted"
    /// by the day-cell view (e.g. days that contain content). Used
    /// by ``DotIndicatorDayCell`` when its `highlighted` flag is
    /// `true`.
    var dayHighlight: Color { get }

    /// Primary text color (visible day numbers in the current month).
    var textPrimary: Color { get }

    /// Secondary text color (weekday header, padding-day numbers).
    var textSecondary: Color { get }
}

/// System-default theme used when the host app doesn't inject one.
///
/// All colors come from `Color.accentColor` and the system's
/// semantic palette so the calendar visually fits any
/// out-of-the-box SwiftUI app.
public struct DefaultMonthCalendarTheme: MonthCalendarTheme {
    /// Creates a default theme. The properties of an instance are
    /// fixed; create a new one if you need to override them.
    public init() {}

    public var accent: Color { .accentColor }
    public var accentSoft: Color { Color.accentColor.opacity(0.12) }
    public var dayHighlight: Color { Color(.secondarySystemBackground) }
    public var textPrimary: Color { .primary }
    public var textSecondary: Color { .secondary }
}

// MARK: - Environment plumbing

private struct MonthCalendarThemeKey: EnvironmentKey {
    static let defaultValue: any MonthCalendarTheme = DefaultMonthCalendarTheme()
}

public extension EnvironmentValues {
    /// The active calendar theme. Inject yours with
    /// `.environment(\.monthCalendarTheme, MyTheme())`.
    var monthCalendarTheme: any MonthCalendarTheme {
        get { self[MonthCalendarThemeKey.self] }
        set { self[MonthCalendarThemeKey.self] = newValue }
    }
}
