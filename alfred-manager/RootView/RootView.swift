//
//  RootView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import SwiftUI

struct RootView: View {
    @StateObject var rootViewModel = RootViewModel()
    
    var body: some View {
        if rootViewModel.alfredInstallationPathSelected {
            ContentView()
        } else {
            InstallationSelectionView()
                .padding()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
