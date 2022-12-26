//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import XCTest

final class SidebarViewModelTests: XCTestCase {

    private var userDefaults: UserDefaultsMock!
    override func setUpWithError() throws {
        userDefaults = UserDefaultsMock()
        userDefaults.objectHandler = { _ in nil }
        userDefaults.setAnyHandler = { _, _ in }
    }

    func test_selectedNavigationOption_storedInUserDefaults_usingCorrectKey() {
        let expectedKey = "selectedNavigationOption"
        var resultKey: String?
        var resultValue: Any?
        userDefaults.setAnyHandler = { value, key in
            resultKey = key
            resultValue = value
        }
        
        userDefaults.objectHandler = { _ in
            SidebarViewModel.NavigationOption.webSearchExport
        }
        
        let viewModel = SidebarViewModel(userDefaults: userDefaults)
        let expectedNavigationOption = SidebarViewModel.NavigationOption.settings
        viewModel.selectedNavigationOption = expectedNavigationOption
        
        XCTAssertEqual(resultKey, expectedKey)
        XCTAssertEqual(resultValue as? Int, expectedNavigationOption.rawValue)
    }
    
    func test_isWebsearchRowInitiallyExpanded() {
        let viewModel = SidebarViewModel(userDefaults: userDefaults)
        
        viewModel.selectedNavigationOption = .webSearchExport
        XCTAssertTrue(viewModel.isWebsearchRowInitiallyExpanded)
        
        viewModel.selectedNavigationOption = .settings
        XCTAssertFalse(viewModel.isWebsearchRowInitiallyExpanded)
        
        viewModel.selectedNavigationOption = .webSearchImport
        XCTAssertTrue(viewModel.isWebsearchRowInitiallyExpanded)
    }
    
    func test_canExpandAndCollapseWebsearchRow() {
        let viewModel = SidebarViewModel(userDefaults: userDefaults)
        
        viewModel.selectedNavigationOption = .webSearchExport
        XCTAssertFalse(viewModel.canExpandAndCollapseWebsearchRow)
        
        viewModel.selectedNavigationOption = .settings
        XCTAssertTrue(viewModel.canExpandAndCollapseWebsearchRow)
        
        viewModel.selectedNavigationOption = .webSearchImport
        XCTAssertFalse(viewModel.canExpandAndCollapseWebsearchRow)
    }
    
    func test_viewModelInit_resetsNavigationOptionToDefault_whenDisabledOptionPersisted() {
        UserDefaults().removePersistentDomain(forName: "test-suite-name")
        let userDefaults = UserDefaults(suiteName: "test-suite-name")!
        userDefaults.set(SidebarViewModel.NavigationOption.workflows.rawValue, forKey: "selectedNavigationOption")
        
        let viewModel = SidebarViewModel(userDefaults: userDefaults)
        
        let defaultNavigationOption = SidebarViewModel.NavigationOption.webSearchExport
        XCTAssertEqual(viewModel.selectedNavigationOption, defaultNavigationOption)
    }
}


fileprivate class UserDefaultsMock: UserDefaults {
    var setAnyCallCount: Int = 0
    var setAnyHandler: (Any?, String) -> Void = { _, _ in fatalError("setAnyHandler not set") }
    override func set(_ value: Any?, forKey defaultName: String) {
        setAnyCallCount += 1
        setAnyHandler(value, defaultName)
    }
    
    var objectCallCount: Int = 0
    var objectHandler: (String) -> Any? = { _ in fatalError("integerHandler not set") }
    override func object(forKey defaultName: String) -> Any? {
        objectCallCount += 1
        return objectHandler(defaultName)
    }
}
