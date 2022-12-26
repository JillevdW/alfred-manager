//
//  WebSearchExportView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

struct WebSearchExportView: View {
    @StateObject var viewModel = WebSearchExportViewModel()
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            selectionList
            
            VStack {
                Divider()
                HStack(spacing: 16) {
                    Spacer()
                    
                    Button(selectionButtonTitle, action: {
                        viewModel.selectOrDeselectAll()
                    }).buttonStyle(.plain)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Button("Export WebSearches", action: {
                        viewModel.selectExportLocation()
                    }).buttonStyle(.borderedProminent)
                        .disabled(viewModel.isSelectionEmpty)
                }.padding()
            }.background(Color(nsColor: NSColor.windowBackgroundColor))
        }
    }
    
    @ViewBuilder
    var selectionList: some View {
        List {
            titleLabel(text: "Select Searches To Export", systemImage: "")
            
            MultipleSelectionView(items: viewModel.webSearches,
                                  selection: $viewModel.selection) { search in
                search.keyword
            } subtitleLabel: { search in
                search.text
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(nsColor: NSColor.windowBackgroundColor))
            )
        }
    }
    
    private var selectionButtonTitle: LocalizedStringKey {
        viewModel.isSelectionEmpty
            ? "Select All"
            : "Deselect All"
    }
    
    private func titleLabel(text: String, systemImage: String) -> some View {
        Label(text, systemImage: systemImage)
            .font(.title.bold())
            .labelStyle(.titleOnly)
    }
}

struct WebSearchExportView_Previews: PreviewProvider {
    static var previews: some View {
        WebSearchExportView()
    }
}
