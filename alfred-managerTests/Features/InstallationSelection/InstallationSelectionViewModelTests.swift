//
//  InstallationSelectionViewModelTests.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import XCTest

final class InstallationSelectionViewModelTests: XCTestCase {

    override class func setUp() {
        super.setUp()
        RootViewContainer.Registrations.push()
        InstallationSelectionContainer.Registrations.push()
    }
    
    override class func tearDown() {
        super.tearDown()
        RootViewContainer.Registrations.pop()
        InstallationSelectionContainer.Registrations.pop()
    }

    func test_onCreate_withURLs_publishesDoneState() {
        let urls = [URL(string: "/test/url")!]
        let alfredPathResolver = createAndRegisterPathResolverMock()
        alfredPathResolver.urlsHandler = { .success(urls) }
        
        let viewModel = InstallationSelectionViewModel()
        
        XCTAssertEqual(viewModel.state, .done(paths: urls))
    }
    
    func test_onCreate_withSupportDirectoryNotFoundError_publishesErrorState() {
        let alfredPathResolver = createAndRegisterPathResolverMock()
        alfredPathResolver.urlsHandler = { .failure(.applicationSupportDirectoryNotFound) }
        
        let viewModel = InstallationSelectionViewModel()
        
        let expectedErrorMessage = AlfredPathResolver.Error.applicationSupportDirectoryNotFound.errorMessage
        XCTAssertEqual(viewModel.state, .error(text: expectedErrorMessage))
    }
    
    func test_onCreate_withAlfredDirectoryNotFoundError_publishesErrorState() {
        let alfredPathResolver = createAndRegisterPathResolverMock()
        alfredPathResolver.urlsHandler = { .failure(.alfredDirectoryNotFound) }
        
        let viewModel = InstallationSelectionViewModel()
        
        let expectedErrorMessage = AlfredPathResolver.Error.alfredDirectoryNotFound.errorMessage
        XCTAssertEqual(viewModel.state, .error(text: expectedErrorMessage))
    }
    
    func test_confirmAlfredPathSelection_storesSelectedURL() {
        let preferencesManager = createAndRegisterPreferencesManagerMock()
        let expectedURL = URL(string: "/test/url")!
        var resultURL: URL?
        preferencesManager.setAlfredInstallationPathHandler = { url in
            resultURL = url
        }
        
        let viewModel = InstallationSelectionViewModel()
        viewModel.confirmAlfredPathSelection(url: expectedURL)
        XCTAssertEqual(resultURL, expectedURL)
    }
    
    // MARK: - Private
    
    private func createAndRegisterPathResolverMock() -> AlfredPathResolvingMock {
        let alfredPathResolver = AlfredPathResolvingMock()
        InstallationSelectionContainer.alfredPathResolver.register { alfredPathResolver }
        return alfredPathResolver
    }
    
    private func createAndRegisterPreferencesManagerMock() -> PreferencesManagingMock {
        let preferencesManager = PreferencesManagingMock()
        RootViewContainer.preferencesManager.register { preferencesManager }
        return preferencesManager
    }
}
