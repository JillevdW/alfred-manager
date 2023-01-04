//
//  WebSearchImportContainer.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 04/01/2023.
//

import Foundation
import Factory
import OSLog

class WebSearchImportContainer: SharedContainer {
    static let logger = Factory(scope: .shared) { Logger.with(category: "WebSearchImport") }
}
