//
//  SystemImage.swift
//  MonthCalendarKit
//
//  Created by Rouzbeh Abadi on 27.04.2026.
//

import SwiftUI

/// Strongly-typed catalog of every SF Symbol used by the package.
///
/// Centralising symbol names here keeps them in one searchable
/// place and avoids stringly-typed `Image(systemName: "...")`
/// calls scattered across views. New symbols added to the package
/// should be appended to this enum rather than referenced inline.
enum SystemImage: String {
    case previousMonth = "chevron.left"
    case nextMonth = "chevron.right"

    /// Renders this symbol as a SwiftUI `Image`. Use this in view
    /// bodies instead of constructing `Image(systemName: ...)`
    /// from the raw string.
    var image: Image {
        Image(systemName: rawValue)
    }
}
