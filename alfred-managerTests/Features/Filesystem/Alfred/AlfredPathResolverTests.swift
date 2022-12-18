//
//  AlfredPathResolverTests.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import XCTest

final class AlfredPathResolverTests: XCTestCase {

    override class func setUp() {
        super.setUp()
    }

    func test_urls_applicationSupportURLNil_returnsFailure() {
        let fileManager = FileManagerMock()
        fileManager.urlsHandler = { _, _ in [] }
        let alfredPathResolver = AlfredPathResolver(fileManager: fileManager)
        
        let result = alfredPathResolver.urls()
        XCTAssertEqual(result, .failure(.applicationSupportDirectoryNotFound))
    }
    
    func test_urls_fileManagerNoContentsOfDirectory_returnsFailure() {
        let fileManager = FileManagerMock()
        fileManager.urlsHandler = { _, _ in [URL(string: "/test/path")!] }
        fileManager.contentsOfDirectoryHandler = { _, _, _ in throw TestError.default }
        let alfredPathResolver = AlfredPathResolver(fileManager: fileManager)
        
        let result = alfredPathResolver.urls()
        XCTAssertEqual(result, .failure(.alfredDirectoryNotFound))
    }
    
    func test_urls_noAlfredFoldersFound_returnsFailure() {
        let fileManager = FileManagerMock()
        fileManager.urlsHandler = { _, _ in [URL(string: "/test/path")!] }
        fileManager.contentsOfDirectoryHandler = { _, _, _ in [
            URL(string: "/test/path/one")!,
            URL(string: "/test/path/two")!,
            URL(string: "/test/path/three")!,
        ]}
        let alfredPathResolver = AlfredPathResolver(fileManager: fileManager)
        
        let result = alfredPathResolver.urls()
        XCTAssertEqual(result, .failure(.alfredDirectoryNotFound))
    }
    
    func test_urls_alfredFolderFound_returnsSuccess() {
        let fileManager = FileManagerMock()
        fileManager.urlsHandler = { _, _ in [URL(string: "/test/path")!] }
        let alfredPaths = [URL(string: "/test/path/Alfred")!]
        fileManager.contentsOfDirectoryHandler = { _, _, _ in alfredPaths }
        let alfredPathResolver = AlfredPathResolver(fileManager: fileManager)
        
        let result = alfredPathResolver.urls()
        XCTAssertEqual(result, .success(alfredPaths))
    }
    
    func test_urls_onlyReturnsFoldersContainingAlfred() {
        let fileManager = FileManagerMock()
        fileManager.urlsHandler = { _, _ in [URL(string: "/test/path")!] }
        let alfredPaths = [
            URL(string: "/test/path/Alfred")!, // Exact match
            URL(string: "/test/path/Alfred 3".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)!, // Specific version
            URL(string: "/test/path/alfred")!, // Case doesn't matter
            URL(string: "/test/path/Alfred-copy")! // Matches anything that contains 'alfred'
        ]
        let otherPaths = [
            URL(string: "/test/path/Alf")!,
            URL(string: "/test/path/Fred")!
        ]
        fileManager.contentsOfDirectoryHandler = { _, _, _ in alfredPaths + otherPaths }
        let alfredPathResolver = AlfredPathResolver(fileManager: fileManager)
        
        let result = alfredPathResolver.urls()
        XCTAssertEqual(result, .success(alfredPaths))
    }
}

enum TestError: Error {
    case `default`
}
