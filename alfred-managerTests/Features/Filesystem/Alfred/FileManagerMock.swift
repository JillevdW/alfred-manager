//
//  FileManagerMock.swift
//  alfred-managerTests
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation

class FileManagerMock: FileManager {
    var urlsCallCount: Int = 0
    var urlsHandler: (FileManager.SearchPathDirectory, FileManager.SearchPathDomainMask) -> [URL] = { _, _ in fatalError() }
    
    override func urls(for directory: FileManager.SearchPathDirectory, in domainMask: FileManager.SearchPathDomainMask) -> [URL] {
        urlsCallCount += 1
        return urlsHandler(directory, domainMask)
    }
    
    var contentsOfDirectoryCallCount: Int = 0
    var contentsOfDirectoryHandler: (URL, [URLResourceKey]?, FileManager.DirectoryEnumerationOptions) throws -> [URL] = { _, _, _ in fatalError() }
    
    override func contentsOfDirectory(at url: URL, includingPropertiesForKeys keys: [URLResourceKey]?, options mask: FileManager.DirectoryEnumerationOptions = []) throws -> [URL] {
        contentsOfDirectoryCallCount += 1
        return try contentsOfDirectoryHandler(url, keys, mask)
    }
}
