//
//  SelectionView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 18/12/2022.
//

import SwiftUI

/// A `View` used to select one element from the `item` `Array`.
struct SingleSelectionView<Element: Hashable>: View {
    let items: [Element]
    @Binding var selection: Element?
    let titleLabel: (Element) -> String
    var subtitleLabel: ((Element) -> String)? = nil
    
    var body: some View {
        InternalSelectionView(items: items,
                              titleLabel: titleLabel,
                              subtitleLabel: subtitleLabel) { element in
            if selection == element {
                selection = nil
            } else {
                selection = element
            }
        } isSelected: { element in
            selection == element
        }
    }
}

/// A `View` used to select any number of elements from the `item` `Array`.
struct MultipleSelectionView<Element: Hashable>: View {
    let items: [Element]
    @Binding var selection: [Element]
    let titleLabel: (Element) -> String
    var subtitleLabel: ((Element) -> String)? = nil
    
    var body: some View {
        InternalSelectionView(items: items,
                              titleLabel: titleLabel,
                              subtitleLabel: subtitleLabel) { element in
            if isSelected(element) {
                selection.removeAll(where: { $0 == element })
            } else {
                selection.append(element)
            }
        } isSelected: { element in
            isSelected(element)
        }
    }
    
    private func isSelected(_ item: Element) -> Bool {
        selection.contains(where: { $0 == item })
    }
}

// MARK: - Private implementation

fileprivate struct InternalSelectionView<Element: Hashable>: View {
    let items: [Element]
    let titleLabel: (Element) -> String
    var subtitleLabel: ((Element) -> String)? = nil
    let onSelected: (Element) -> Void
    let isSelected: (Element) -> Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(items, id: \.self) { item in
                ZStack {
                    Button {
                        onSelected(item)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: isSelected(item) ? "checkmark.circle.fill" : "circle")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text(titleLabel(item))
                                    .font(.headline)
                                
                                if let subtitle = subtitleLabel?(item) {
                                    Text(subtitle)
                                        .font(.subheadline)
                                }
                            }
                            Spacer()
                        }.frame(maxWidth: .infinity)
                        .contentShape(Rectangle())
                    }.buttonStyle(.plain)
                }.padding()
                .background(
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(nsColor: NSColor.controlBackgroundColor))
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isSelected(item)
                                    ? Color.blue
                                    : Color.clear,
                                lineWidth: 2
                            )
                    }
                )
            }
        }.frame(maxWidth: .infinity)
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        WrapperView()
    }
}

private struct WrapperView: View {
    let labels = ["Test 1", "Test 2", "Test 3", "Test 4"]
    @State var singleSelection: String?
    @State var multiSelection: [String] = []
    
    let titleLabel = { (label: String) in
        return label
    }
    
    let subtitleLabel = { (label: String) in
        return label + " " + label + " " + label + " " + label
    }
    
    var body: some View {
        SingleSelectionView(items: labels,
                            selection: $singleSelection,
                            titleLabel: titleLabel,
                            subtitleLabel: subtitleLabel)
            .previewDisplayName("Single Selection")
        
        MultipleSelectionView(items: labels,
                              selection: $multiSelection,
                              titleLabel: titleLabel)
            .previewDisplayName("Multiple Selection")
    }
}
