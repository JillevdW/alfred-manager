//
//  PreferencesManagerTests.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import XCTest

final class PreferencesManagerTests: XCTestCase {

    private var preferencesManager: PreferencesManager!
    private var userDefaults: UserDefaultsMock!
    
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        preferencesManager = PreferencesManager(userDefaults: userDefaults)
    }
    
    func test_setAlfredInstallationPath_writesToUserDefaults() {
        var resultURL: URL?
        var resultKey: String?
        userDefaults.setUrlHandler = { url, key in
            resultURL = url
            resultKey = key
        }
        
        let expectedURL = URL(string: "/test/url")
        preferencesManager.setAlfredInstallationPath(expectedURL)
        
        XCTAssertEqual(userDefaults.setUrlCallCount, 1)
        XCTAssertEqual(resultURL, expectedURL)
        XCTAssertEqual(resultKey, "alfredInstallationPath")
    }
    
    func test_alfredInstallationPath_readsFromUserDefaults() {
        var resultKey: String?
        let expectedURL = URL(string: "/test/url")
        userDefaults.urlHandler = { key in
            resultKey = key
            return expectedURL
        }
        
        let resultURL = preferencesManager.alfredInstallationPath
        XCTAssertEqual(userDefaults.urlCallCount, 1)
        XCTAssertEqual(resultURL, expectedURL)
        XCTAssertEqual(resultKey, "alfredInstallationPath")
    }
}

fileprivate class UserDefaultsMock: UserDefaults {
    var setUrlCallCount: Int = 0
    var setUrlHandler: (URL?, String) -> Void = { _, _ in fatalError("setUrlHandler not set") }
    override func set(_ url: URL?, forKey defaultName: String) {
        setUrlCallCount += 1
        setUrlHandler(url, defaultName)
    }
    
    var urlCallCount: Int = 0
    var urlHandler: (String) -> URL? = { _ in fatalError("urlHandler not set") }
    override func url(forKey defaultName: String) -> URL? {
        urlCallCount += 1
        return urlHandler(defaultName)
    }
}
