//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import Foundation
import SwiftUI

extension SidebarViewModel {
    enum NavigationOption: Int, Hashable {
        case webSearchExport
        case webSearchImport
        case workflows
        case settings
    }
}

class SidebarViewModel: ViewModel {
    /// The currently selected sidebar navigation option. Persists across app launches.
    @AppStorage var selectedNavigationOption: NavigationOption
    
    init(userDefaults: UserDefaults = .standard) {
        _selectedNavigationOption = AppStorage(wrappedValue: .webSearchExport, "selectedNavigationOption", store: userDefaults)
    }
    
    // MARK: - Websearch Row
    
    var isWebsearchRowInitiallyExpanded: Bool {
        selectedNavigationOption == .webSearchExport || selectedNavigationOption == .webSearchImport
    }
    
    var canExpandAndCollapseWebsearchRow: Bool {
        selectedNavigationOption != .webSearchExport && selectedNavigationOption != .webSearchImport
    }
}
