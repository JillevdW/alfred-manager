//
//  InstallationSelectionContainer.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory

class InstallationSelectionContainer: SharedContainer {
    static let fileManager = Factory<FileManager> { FileManager.default }
    static let alfredPathResolver = Factory<AlfredPathResolving> { AlfredPathResolver(fileManager: fileManager()) }
    static let preferencesManager = RootViewContainer.preferencesManager
}
