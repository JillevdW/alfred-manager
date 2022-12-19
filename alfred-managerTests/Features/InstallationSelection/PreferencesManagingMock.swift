//
//  PreferencesManagingMock.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import Foundation

class PreferencesManagingMock: PreferencesManaging {
    var setAlfredInstallationPathCallCount: Int = 0
    var setAlfredInstallationPathHandler: (URL?) -> Void = { _ in fatalError("setAlfredInstallationPathHandler not set") }
    func setAlfredInstallationPath(_ url: URL?) {
        setAlfredInstallationPathCallCount += 1
        setAlfredInstallationPathHandler(url)
    }
    
    var alfredInstallationPathCallCount: Int = 0
    var alfredInstallationPathHandler: () -> URL? = { fatalError("alfredInstallationPathHandler not set") }
    var alfredInstallationPath: URL? {
        alfredInstallationPathCallCount += 1
        return alfredInstallationPathHandler()
    }
}
