//
//  RootViewContainer.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory

class RootViewContainer: SharedContainer {
    static let preferencesManager = Factory<PreferencesManaging>(scope: .shared) {
        PreferencesManager(userDefaults: .standard)
    }
}
