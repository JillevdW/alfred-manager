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
    
    // MARK: - Private
    
    private func createAndRegisterPathResolverMock() -> AlfredPathResolvingMock {
        let alfredPathResolver = AlfredPathResolvingMock()
        InstallationSelectionContainer.alfredPathResolver.register { alfredPathResolver }
        return alfredPathResolver
    }
}
