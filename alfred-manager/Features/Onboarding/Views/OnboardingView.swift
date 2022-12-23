//
//  Copyright © Uber Technologies, Inc. All rights reserved.
//


import SwiftUI

struct OnboardingView: View {
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
                
                onboardingItem(systemImage: "externaldrive.badge.timemachine",
                               headline: "Backup your preferences",
                               subheadline: "Backing up could be a use-case for Alfred Manager. But simply storing the Alfred preferences in GDrive works for that too 🤷")
                
                onboardingItem(systemImage: "globe",
                               headline: "Export everything",
                               subheadline: "Want to share workflows? Snippets? Anything you can think of that we can find in the preferences?",
                               headlineBadge: "Soon")
                
            }.padding(.horizontal, 48)
            
            Button("Continue") {
                //
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
                        
                        Text(headlineBadge)
                            .font(.footnote)
                            .foregroundColor(Color(nsColor: .textBackgroundColor))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background {
                                RoundedRectangle(cornerRadius: 4).fill(.green)
                            }
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

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .frame(width: 400)
            .padding()
    }
}
