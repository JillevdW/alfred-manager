//
//  SidebarView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

struct SidebarView: View {
    @StateObject var viewModel = SidebarViewModel()
    
    var body: some View {
        NavigationView {
            List(selection: $viewModel.selectedNavigationOption) {
                Section {
                    SidebarDisclosureRow(
                        isInitiallyExpanded: viewModel.isWebsearchRowInitiallyExpanded,
                        canExpandAndCollapse: viewModel.canExpandAndCollapseWebsearchRow
                    ) {
                        NavigationLink {
                            WebSearchExportView()
                        } label: {
                            Label("Export", systemImage: "arrow.up.doc")
                        }.tag(SidebarViewModel.NavigationOption.webSearchExport)
                        
                        NavigationLink {
                            WebSearchImportView()
                        } label: {
                            Label("Import", systemImage: "arrow.down.doc")
                        }.tag(SidebarViewModel.NavigationOption.webSearchImport)
                    } label: {
                        Label("Web Search", systemImage: "magnifyingglass.circle")
                    }
                    
                    NavigationLink {
                        Text("Workflows")
                    } label: {
                        HStack(alignment: .center, spacing: 3) {
                            Label("Workflows", systemImage: "app.connected.to.app.below.fill")
                                .layoutPriority(1)
                            BadgeTextView(text: "Soon")
                                .font(.footnote)
                                .layoutPriority(0)
                        }
                    }
                    .tag(SidebarViewModel.NavigationOption.workflows)
                    .disabled(true)
                }
                
                Section {
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }.tag(SidebarViewModel.NavigationOption.settings)
                }
            }.listStyle(.sidebar)
        }.toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar, label: {
                    Image(systemName: "sidebar.leading")
                })
            }
        }
    }
    
    private func toggleSidebar() {
        #if os(iOS)
        #else
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
