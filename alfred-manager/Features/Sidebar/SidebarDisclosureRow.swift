//
//  SidebarDisclosureRow.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

/// An expandable row to be displayed in the Application's sidebar. The row itself can not be selected,
/// but the content provided through the `content` parameter can.
struct SidebarDisclosureRow<Content: View, Label: View>: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let label: () -> Label
    /// Denotes whether the disclosure group can be opened/closed.
    let canExpandAndCollapse: () -> Bool
    
    @State private var isExpanded: Bool
    
    /// - Parameters:
    ///   - isInitiallyExpanded: sets the initial expanded/collapsed state.
    ///   - content: The content that will be selectable in the Sidebar.
    ///   - label: The label that will allow for expanding and collapsing the content.
    ///   - canExpandAndCollapse: controls whether the row can be opened or closed,
    ///   for example to disallow closing of the row when one of its children is selected.
    init(isInitiallyExpanded: Bool = false,
         @ViewBuilder content: @escaping () -> Content,
         @ViewBuilder label: @escaping () -> Label,
         canExpandAndCollapse: @escaping () -> Bool  = { true }) {
        self.content = content
        self.label = label
        self.canExpandAndCollapse = canExpandAndCollapse
        _isExpanded = State(initialValue: isInitiallyExpanded)
    }
    
    var body: some View {
        HStack {
            label()

            Spacer()

            Image(systemName: "chevron.right")
                .rotationEffect(Angle(degrees: isExpanded ? 90 : 0 ))
        }.onTapGesture {
            withAnimation {
                guard canExpandAndCollapse() else {
                    return
                }
                isExpanded.toggle()
            }
        }

        if isExpanded {
            content()
                .padding(.leading, 8)
        }
    }
}

struct SidebarDisclosureView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarDisclosureRow {
            Text("First item")
            Text("Second item")
        } label: {
            Text("Disclosure Label")
        }.previewDisplayName("Regular")
        
        SidebarDisclosureRow(isInitiallyExpanded: true) {
            Text("First item")
            Text("Second item")
        } label: {
            Text("Disclosure Label")
        }.previewDisplayName("Initially expanded")

        SidebarDisclosureRow(isInitiallyExpanded: true) {
            Text("First item")
            Text("Second item")
        } label: {
            Text("Disclosure Label")
        }.previewDisplayName("Not collapsible")
    }
}
