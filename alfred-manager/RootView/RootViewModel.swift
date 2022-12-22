//
//  RootViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import Foundation
import Factory

class RootViewModel: ViewModel {
    @Injected(RootViewContainer.preferencesManager) var preferencesManager
    @Published var alfredInstallationPathSelected = false
    
    override func onCreate() {
        super.onCreate()
        
        preferencesManager.alfredInstallationPathStream
            .receive(on: DispatchQueue.main)
            .sink { [weak self] url in
                self?.alfredInstallationPathSelected = url != nil
            }.store(in: &lifecycle)
    }
}
