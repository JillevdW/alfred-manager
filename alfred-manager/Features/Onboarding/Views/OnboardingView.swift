//
//  OnboardingView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 23/12/2022.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isShowingOnboardingModal = true
    
    var body: some View {
        InstallationSelectionView()
            .padding()
            .sheet(isPresented: $isShowingOnboardingModal) {
                OnboardingModal()
                    .padding()
                    .frame(width: 500)
            }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
