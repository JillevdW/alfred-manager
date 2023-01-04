//
//  Logger.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 04/01/2023.
//

import Foundation
import OSLog

extension Logger {
    /// Creates a `Logger`with the given category and the application bundle identifier as the `subsystem`, or `"alfred-manager` if the bundle identifier is nil.
    static func with(category: String) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "alfred-manager", category: category)
    }
}
