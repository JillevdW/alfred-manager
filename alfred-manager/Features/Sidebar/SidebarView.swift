//
//  SidebarView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

extension SidebarView {
    enum NavigationOption: Int, Hashable {
        case webSearchExport
        case webSearchImport
        case workflows
        case settings
    }
}

struct SidebarView: View {
    /// The currently selected sidebar navigation option. Persists across app launches.
    @AppStorage("selectedNavigationOption") private var selectedNavigationOption: NavigationOption = .webSearchExport
    var body: some View {
        NavigationView {
            List(selection: $selectedNavigationOption) {
                Section {
                    SidebarDisclosureRow(isInitiallyExpanded: selectedNavigationOption == .webSearchExport || selectedNavigationOption == .webSearchImport) {
                        NavigationLink {
                            WebSearchExportView()
                        } label: {
                            Label("Export", systemImage: "arrow.up.doc")
                        }.tag(NavigationOption.webSearchExport)
                        
                        NavigationLink {
                            Text("Import")
                        } label: {
                            Label("Import", systemImage: "arrow.down.doc")
                        }.tag(NavigationOption.webSearchImport)
                    } label: {
                        Label("Web Search", systemImage: "magnifyingglass.circle")
                    } canExpandAndCollapse: {
                        selectedNavigationOption != .webSearchExport && selectedNavigationOption != .webSearchImport
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
                    .tag(NavigationOption.workflows)
                    .disabled(true)
                }
                
                Section {
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }.tag(NavigationOption.settings)
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
