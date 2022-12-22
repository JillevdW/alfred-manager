//
//  PreferencesManager.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import Foundation
import Combine

protocol PreferencesManaging {
    func setAlfredInstallationPath(_ url: URL?)
    var alfredInstallationPath: URL? { get }
    var alfredInstallationPathStream: AnyPublisher<URL?, Never> { get }
}

class PreferencesManager: PreferencesManaging {
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
        
        initializeSubjects()
    }
    
    private func initializeSubjects() {
        let alfredInstallationPath = userDefaults.url(forKey: alfredInstallationPathKey)
        alfredInstallationPathSubject.send(alfredInstallationPath)
    }
    
    // MARK: - Alfred Installation Path
    
    private let alfredInstallationPathKey = "alfredInstallationPath"
    
    private let alfredInstallationPathSubject: CurrentValueSubject<URL?, Never> = CurrentValueSubject(nil)
    var alfredInstallationPathStream: AnyPublisher<URL?, Never> {
        alfredInstallationPathSubject.eraseToAnyPublisher()
    }
    
    var alfredInstallationPath: URL? {
        alfredInstallationPathSubject.value
    }
    
    func setAlfredInstallationPath(_ url: URL?) {
        alfredInstallationPathSubject.send(url)
        userDefaults.set(url, forKey: alfredInstallationPathKey)
    }
}
