//
//  InstallationSelectionViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory

extension InstallationSelectionViewModel {
    enum State {
        case loading
        case error(text: String)
        case done(paths: [URL])
    }
}

class InstallationSelectionViewModel: ViewModel {
    @Injected(InstallationSelectionContainer.alfredPathResolver) private var alfredPathResolver
    @Published var state: State = .loading

    override func onCreate() {
        let result = alfredPathResolver.urls()
        
        switch result {
        case .success(let urls):
            state = .done(paths: urls)
        case .failure(let error):
            state = .error(text: "\(error.localizedDescription)")
        }
    }
    
    // TODO: Recovery from errors can be achieved by allowing the user to manually select their Alfred directory.
}
