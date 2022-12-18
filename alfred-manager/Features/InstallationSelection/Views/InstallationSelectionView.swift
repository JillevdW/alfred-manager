//
//  InstallationSelectionView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import SwiftUI

struct InstallationSelectionView: View {
    @StateObject private var viewModel = InstallationSelectionViewModel()
    @State private var selection: URL?
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                Text("Select your") +
                Text(" Alfred ")
                    .foregroundColor(.blue) +
                Text("folder")
            }
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                
            switch viewModel.state {
            case .loading:
                Text("Looking for Alfred installations...")
                
            case .done(paths: let urls):
                SingleSelectionView(items: urls,
                                    selection: $selection) { url in
                    url.absoluteString.removingPercentEncoding ?? "-"
                }
                
                
            case .error(text: let text):
                Text(text)
                    .foregroundColor(.red)
            }
        }
    }
}

struct InstallationSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        InstallationSelectionView()
    }
}
