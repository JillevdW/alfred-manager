//
//  WebSearchImportDropView.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 29/12/2022.
//

import SwiftUI

struct WebSearchImportDropView: View {
    @ObservedObject var viewModel = WebSearchImportViewModel()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [10]))
                .foregroundColor(dropBorderColor)
                .padding()
            
            VStack {
                Text("Drop the file you want to import here")
                    .font(.system(.title))
                    .foregroundColor(.secondary)
            }
        }.onDrop(of: [.propertyList], delegate: viewModel)
    }
    
    private var dropBorderColor: Color {
        viewModel.isDropItemWithinBounds
            ? .green.opacity(0.8)
            : .secondary.opacity(0.8)
    }
}

struct WebSearchImportDropView_Previews: PreviewProvider {
    static var previews: some View {
        WebSearchImportDropView()
    }
}
