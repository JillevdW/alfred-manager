//
//  InstallationSelectionViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory
import SwiftUI

extension InstallationSelectionViewModel {
    enum State: Equatable {
        case loading
        case error(text: String)
        case done(paths: [URL])
    }
}

class InstallationSelectionViewModel: ViewModel {
    @Injected(InstallationSelectionContainer.alfredPathResolver) private var alfredPathResolver
    @Injected(InstallationSelectionContainer.preferencesManager) private var preferencesManager
    @Published var state: State = .loading

    override func onCreate() {
        super.onCreate()
        loadAlfredURLs()
    }
    
    private func loadAlfredURLs() {
        let result = alfredPathResolver.urls()
        
        switch result {
        case .success(let urls):
            state = .done(paths: urls)
        case .failure(let error):
            state = .error(text: error.errorMessage)
        }
    }
    
    func confirmAlfredPathSelection(url: URL) {
        preferencesManager.setAlfredInstallationPath(url)
    }
    
    // TODO: Recovery from errors can be achieved by allowing the user to manually select their Alfred directory.
}
