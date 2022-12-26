//
//  SidebarViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
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
    
    private let defaultNavigationOption: NavigationOption = .webSearchExport
    private let selectedNavigationOptionUserDefaultsKey = "selectedNavigationOption"
    private let disabledNavigationOptions: Set<NavigationOption> = [
        .workflows
    ]
    
    init(userDefaults: UserDefaults = .standard) {
        if let persistedOption = userDefaults.object(forKey: selectedNavigationOptionUserDefaultsKey),
           let persistedRawValue = persistedOption as? Int,
           disabledNavigationOptions.contains(where: { $0.rawValue == persistedRawValue }) {
            userDefaults.set(defaultNavigationOption.rawValue, forKey: selectedNavigationOptionUserDefaultsKey)
        }
        
        _selectedNavigationOption = AppStorage(wrappedValue: defaultNavigationOption,
                                               selectedNavigationOptionUserDefaultsKey,
                                               store: userDefaults)
    }
    
    // MARK: - Websearch Row
    
    var isWebsearchRowInitiallyExpanded: Bool {
        selectedNavigationOption == .webSearchExport || selectedNavigationOption == .webSearchImport
    }
    
    var canExpandAndCollapseWebsearchRow: Bool {
        selectedNavigationOption != .webSearchExport && selectedNavigationOption != .webSearchImport
    }
}
