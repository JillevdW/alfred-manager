//
//  SidebarDisclosureRow.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 24/12/2022.
//

import SwiftUI

struct SidebarDisclosureRow<Content: View, Label: View>: View {
    @ViewBuilder let content: () -> Content
    @ViewBuilder let label: () -> Label
    /// Denotes whether the disclosure group can be opened/closed.
    let canExpandAndCollapse: () -> Bool
    
    @State private var isExpanded: Bool
    
    init(@ViewBuilder content: @escaping () -> Content,
         @ViewBuilder label: @escaping () -> Label,
         canExpandAndCollapse: @escaping () -> Bool  = { true }) {
        self.content = content
        self.label = label
        self.canExpandAndCollapse = canExpandAndCollapse
        _isExpanded = State(initialValue: !canExpandAndCollapse())
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
        }
    }
}
