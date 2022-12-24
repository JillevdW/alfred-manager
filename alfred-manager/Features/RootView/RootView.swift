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
        switch rootViewModel.state {
        case .loading, .pathSelected:
            SidebarView()
        case .pathNotSelected:
            OnboardingView()
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}
