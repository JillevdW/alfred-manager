//
//  AlfredPathResolver.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation

protocol AlfredPathResolving {
    func urls() -> Result<[URL], AlfredPathResolver.Error>
}

class AlfredPathResolver: AlfredPathResolving {
    private let fileManager: FileManager
    
    init(fileManager: FileManager) {
        self.fileManager = fileManager
    }
    
    // MARK: - Public API
    
    /// Returns a `Result` with either an `Array` containing paths of potential Alfred directories or an `Error`.
    func urls() -> Result<[URL], Error> {
        guard let applicationSupportDirectory = applicationSupportURL() else {
            return .failure(.applicationSupportDirectoryNotFound)
        }
        
        guard let alfredURLs = alfredURLs(inDirectory: applicationSupportDirectory),
              !alfredURLs.isEmpty else {
            return .failure(.alfredDirectoryNotFound)
        }
        
        return .success(alfredURLs)
    }
    
    // MARK: - Private
    
    private func applicationSupportURL() -> URL? {
        fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
    }
    
    private func alfredURLs(inDirectory directory: URL) -> [URL]? {
        guard let contents = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return nil
        }
        
        return contents.filter { url in
            url.lastPathComponent.lowercased().contains("alfred")
        }
    }
}

extension AlfredPathResolver {
    enum Error: Swift.Error {
        case applicationSupportDirectoryNotFound
        case alfredDirectoryNotFound
        
        var errorMessage: String {
            switch self {
            case .applicationSupportDirectoryNotFound:
                return "No Alfred folder found. Are you sure you have Alfred installed?"
            case .alfredDirectoryNotFound:
                return "Application Support directory not found. Please submit a bug report."
            }
        }
    }
}
