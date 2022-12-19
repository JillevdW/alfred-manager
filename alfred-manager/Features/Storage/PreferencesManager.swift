//
//  PreferencesManager.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import Foundation

protocol PreferencesManaging {
    func setAlfredInstallationPath(_ url: URL?)
    var alfredInstallationPath: URL? { get }
}

class PreferencesManager: PreferencesManaging {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - Alfred Installation Path
    
    private let alfredInstallationPathKey = "alfredInstallationPath"
    
    var alfredInstallationPath: URL? {
        userDefaults.url(forKey: alfredInstallationPathKey)
    }
    
    func setAlfredInstallationPath(_ url: URL?) {
        userDefaults.set(url, forKey: alfredInstallationPathKey)
    }
}
