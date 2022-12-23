//
//  alfred_managerApp.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import SwiftUI

@main
struct alfred_managerApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
        .commands {
            #if DEBUG
            CommandMenu("Developer Menu") {
                Button("Clear Alfred Installation Path") {
                    RootViewContainer.preferencesManager().setAlfredInstallationPath(nil)
                }
            }
            #endif
        }
    }
}
