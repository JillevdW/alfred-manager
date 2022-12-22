//
//  PreferencesManagerTests.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 19/12/2022.
//

import XCTest
import Combine

final class PreferencesManagerTests: XCTestCase {

    private var userDefaults: UserDefaultsMock!
    private var testCancellable: AnyCancellable?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        userDefaults = UserDefaultsMock()
        userDefaults.urlHandler = { _ in nil }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        testCancellable?.cancel()
    }
    
    func test_preferencesManager_initializesStreamWithUserDefaultsValue_onInit() {
        let expectedURL = URL(string: "/test/url")
        var resultKey: String?
        userDefaults.urlHandler = { key in
            resultKey = key
            return expectedURL
        }
        
        let preferencesManager = preferencesManager()
        var resultURL: URL?
        let _ = preferencesManager.alfredInstallationPathStream.sink { url in
            resultURL = url
        }
        
        XCTAssertEqual(resultURL, expectedURL)
        XCTAssertEqual(resultKey, "alfredInstallationPath")
    }
    
    func test_setAlfredInstallationPath_writesToUserDefaults() {
        var resultURL: URL?
        var resultKey: String?
        userDefaults.setUrlHandler = { url, key in
            resultURL = url
            resultKey = key
        }
        
        let preferencesManager = preferencesManager()
        let expectedURL = URL(string: "/test/url")
        preferencesManager.setAlfredInstallationPath(expectedURL)
        
        XCTAssertEqual(userDefaults.setUrlCallCount, 1)
        XCTAssertEqual(resultURL, expectedURL)
        XCTAssertEqual(resultKey, "alfredInstallationPath")
    }
    
    func test_setAlfredInstallationPath_updatesStream() {
        userDefaults.setUrlHandler = { _, _ in }
        let preferencesManager = preferencesManager()
        
        var streamURLs: [URL?] = []
        testCancellable = preferencesManager.alfredInstallationPathStream.sink { url in
            streamURLs.append(url)
        }
        
        let urls = [
            URL(string: "/test/url"),
            URL(string: "/file/path"),
            nil
        ]

        urls.forEach { url in
            preferencesManager.setAlfredInstallationPath(url)
        }
        
        XCTAssertEqual(streamURLs, [nil] + urls)
    }
    
    func test_alfredInstallationPath_readsFromCurrentStreamValue() {
        let expectedURL = URL(string: "/test/url")
        userDefaults.urlHandler = { key in
            return expectedURL
        }
        
        let preferencesManager = preferencesManager()
        
        var streamValue: URL?
        let _ = preferencesManager.alfredInstallationPathStream.sink { url in
            streamValue = url
        }
        
        XCTAssertEqual(userDefaults.urlCallCount, 1)
        XCTAssertEqual(preferencesManager.alfredInstallationPath, streamValue)
    }
    
    // MARK: - Private
    
    private func preferencesManager() -> PreferencesManaging {
        PreferencesManager(userDefaults: userDefaults)
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
