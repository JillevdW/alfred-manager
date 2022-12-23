//
//  RootViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory

extension RootViewModel {
    enum State {
        case loading
        case pathSelected
        case pathNotSelected
    }
}

class RootViewModel: ViewModel {
    @Injected(RootViewContainer.preferencesManager) var preferencesManager
    @Published var state: State = .loading
    
    override func onCreate() {
        super.onCreate()
        
        preferencesManager.alfredInstallationPathStream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.state = url != nil ? .pathSelected : .pathNotSelected
            }.store(in: &lifecycle)
    }
}
