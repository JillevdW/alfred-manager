//
//  WebSearchImportView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 29/12/2022.
//

import SwiftUI

struct WebSearchImportView: View {
    @StateObject var viewModel = WebSearchImportViewModel()
    
    var body: some View {
        NavigationStack(root: {
            selectFileView
                .navigationDestination(isPresented: $viewModel.isShowingSelectionScreen) {
                    selectionSheet
                }
        })
    }
    
    @ViewBuilder
    private var selectFileView: some View {
        VStack {
            WebSearchImportDropView(viewModel: viewModel)
            
            HStack {
                VStack {
                    Divider()
                }
                
                Text("Or select the file here")
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
                
                VStack {
                    Divider()
                }
            }.padding(.bottom)
            
            Button {
                viewModel.selectConfigurationPath()
            } label: {
                TextField("Click here to select /path/to/configuration-to-import", text: .constant(""))
                    .disabled(true)
                    .padding(.horizontal)
                    .padding(.bottom)
            }.buttonStyle(.link)
        }
    }
    
    private var selectionSheet: some View {
        VStack(alignment: .leading, spacing: 0) {
            List {
                MultipleSelectionView(items: viewModel.webSearches,
                                      selection: $viewModel.selection) { search in
                    search.keyword
                } subtitleLabel: { search in
                    search.text
                }.padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(nsColor: NSColor.windowBackgroundColor))
                )
            }
            
            VStack {
                Divider()
                HStack(spacing: 16) {
                    Spacer()
                    
                    Button(selectionButtonTitle, action: {
                        viewModel.selectOrDeselectAll()
                    }).buttonStyle(.plain)
                        .fixedSize(horizontal: true, vertical: false)
                    
                    Button("Import selection", action: {
                        // TODO: .
                    }).buttonStyle(.borderedProminent)
                        .disabled(viewModel.isSelectionEmpty)
                }.padding()
            }.background(Color(nsColor: NSColor.windowBackgroundColor))
        }
    }
    
    private var selectionButtonTitle: LocalizedStringKey {
        viewModel.isSelectionEmpty
            ? "Select All"
            : "Deselect All"
    }
}

struct WebSearchImportView_Previews: PreviewProvider {
    static var previews: some View {
        WebSearchImportView()
    }
}
