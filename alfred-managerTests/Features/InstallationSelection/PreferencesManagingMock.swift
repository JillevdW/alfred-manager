//
//  PreferencesManagingMock.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import Foundation
import Combine

class PreferencesManagingMock: PreferencesManaging {
    var alfredInstallationPathStreamCallCount: Int = 0
    var alfredInstallationPathStreamHandler: () -> AnyPublisher<URL?, Never> = { fatalError("alfredInstallationPathStreamHandler not set") }
    var alfredInstallationPathStream: AnyPublisher<URL?, Never> {
        alfredInstallationPathStreamCallCount += 1
        return alfredInstallationPathStreamHandler()
    }
    
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
