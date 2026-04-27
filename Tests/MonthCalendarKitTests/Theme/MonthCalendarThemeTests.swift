//
//  MonthCalendarThemeTests.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import XCTest
import SwiftUI
@testable import MonthCalendarKit

final class MonthCalendarThemeTests: XCTestCase {

    // MARK: - Defaults

    func testDefaultTheme_isProvidedWhenNoneInjected() {
        // The environment value should always have a non-nil
        // theme, even when the host app does nothing — otherwise
        // `MonthCalendarView` would crash on first read.
        let env = EnvironmentValues()
        XCTAssertNotNil(env.monthCalendarTheme)
    }

    func testDefaultTheme_canBeInstantiatedDirectly() {
        // Confirms the default initialiser is public and that all
        // protocol requirements are satisfied.
        let theme = DefaultMonthCalendarTheme()
        _ = theme.accent
        _ = theme.accentSoft
        _ = theme.dayHighlight
        _ = theme.textPrimary
        _ = theme.textSecondary
    }

    // MARK: - Custom themes

    private struct TestTheme: MonthCalendarTheme {
        var accent: Color { .red }
        var accentSoft: Color { .red.opacity(0.1) }
        var dayHighlight: Color { .gray }
        var textPrimary: Color { .black }
        var textSecondary: Color { .secondary }
    }

    func testCustomTheme_flowsThroughEnvironment() {
        var env = EnvironmentValues()
        env.monthCalendarTheme = TestTheme()
        XCTAssertEqual(env.monthCalendarTheme.accent, .red)
        XCTAssertEqual(env.monthCalendarTheme.textPrimary, .black)
    }

    func testCustomTheme_replacesPreviousValue() {
        var env = EnvironmentValues()
        env.monthCalendarTheme = TestTheme()
        XCTAssertEqual(env.monthCalendarTheme.accent, .red)

        env.monthCalendarTheme = DefaultMonthCalendarTheme()
        XCTAssertEqual(env.monthCalendarTheme.accent, .accentColor)
    }
}
