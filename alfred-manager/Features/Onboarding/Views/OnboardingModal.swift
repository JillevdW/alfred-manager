//
//  OnboardingModal.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 23/12/2022.
//

import SwiftUI

struct OnboardingModal: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 16) {
            Group {
                Text("Welcome to ")
                    .font(.largeTitle)
                + Text("Alfred Manager")
                    .font(.largeTitle)
            }.bold()
            
            VStack(alignment: .leading, spacing: 16) {
                onboardingItem(systemImage: "square.and.arrow.up",
                               headline: "Share your shortcuts",
                               subheadline: "Export the shortcuts you created with teammates. Be the impact multiplier you've always wanted to be!")
                
                onboardingItem(systemImage: "arrow.down.to.line",
                               headline: "Get new shortcuts",
                               subheadline: "Import shortcuts that someone else shared with you or download them from the internet.")
                
                onboardingItem(systemImage: "map",
                               headline: "Discover",
                               subheadline: "Discover curated Alfred shortcuts, the crème de la crème if you will :)",
                               headlineBadge: "Soon")
                
                onboardingItem(systemImage: "globe",
                               headline: "Export everything",
                               subheadline: "Want to share workflows? Snippets? Anything you can think of that we can find in the preferences?",
                               headlineBadge: "Soon")
            }.padding(.horizontal, 48)
            
            Button("Continue") {
                dismiss()
            }.buttonStyle(.borderedProminent)
                .tint(.accentColor)
        }
    }
    
    private func onboardingItem(
        systemImage: String,
        headline: String,
        subheadline: String,
        headlineBadge: String? = nil
    ) -> some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: systemImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .tint(.accentColor)
                .frame(width: 36, height: 36)
                
                
            VStack(alignment: .leading, spacing: 4) {
                if let headlineBadge {
                    HStack(spacing: 4) {
                        Text(headline)
                            .font(.headline)
                        
                        BadgeTextView(text: headlineBadge)
                            .font(.footnote)
                    }
                } else {
                    Text(headline)
                        .font(.headline)
                }
                Text(subheadline)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct OnboardingModal_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingModal()
            .frame(width: 400)
            .padding()
    }
}
