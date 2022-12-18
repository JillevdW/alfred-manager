//
//  InstallationSelectionContainerTests.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import XCTest

final class InstallationSelectionContainerTests: XCTestCase {

    func test_alfredPathResolver_usesInjectedFileManager() throws {
        let fileManager = FileManager()
        InstallationSelectionContainer.fileManager.register { fileManager }
        var didResolveFileManager = false
        InstallationSelectionContainer.Decorator.decorate = { object in
            switch object {
            case is AlfredPathResolving:
                break
            case is FileManager:
                didResolveFileManager = true
            default:
                XCTFail()
            }
        }
        
        let _ = InstallationSelectionContainer.alfredPathResolver.callAsFunction()
        XCTAssertTrue(didResolveFileManager)
    }
}
