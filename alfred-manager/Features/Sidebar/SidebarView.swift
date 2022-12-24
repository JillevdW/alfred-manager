//
//  SidebarView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

struct SidebarView: View {
    var body: some View {
        NavigationView {
            List {
                Section {
                    NavigationLink {
                        Text("Web Search")
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
                    }.disabled(true)
                }
                
                Section {
                    NavigationLink {
                        Text("Settings")
                    } label: {
                        Label("Settings", systemImage: "gear")
                    }
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
