//
//  WebSearchImportViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 29/12/2022.
//

import Foundation
import SwiftUI

class WebSearchImportViewModel: ViewModel {
    @Published private (set) var isDropItemWithinBounds = false
    @Published private (set) var webSearches: [WebSearch] = []
    @Published var selection: [WebSearch] = []
    @Published var isShowingSelectionScreen = false
    
    override func onCreate() {
        super.onCreate()
        
        $isShowingSelectionScreen
            .removeDuplicates()
            .filter { isShowingSelectionScreen in !isShowingSelectionScreen }
            .sink { [weak self] isShowingSelectionScreen in
                self?.resetWebSearchSelection()
            }.store(in: &lifecycle)
    }
    
    var isSelectionEmpty: Bool {
        selection.isEmpty
    }
    
    func selectOrDeselectAll() {
        if isSelectionEmpty {
            selection = webSearches
        } else {
            selection = []
        }
    }
    
    // MARK: - Private
    
    private func presentWebSearchSelection(webSearches: [WebSearch]) {
        self.webSearches = webSearches
        self.isShowingSelectionScreen = true
    }
    
    private func resetWebSearchSelection() {
        self.webSearches = []
        self.selection = []
    }
}

// MARK: - DropDelegate

extension WebSearchImportViewModel: DropDelegate {
    func performDrop(info: DropInfo) -> Bool {
        print(info)
        guard let itemProvider = info.itemProviders(for: [.propertyList]).first else {
            // TODO: Unknown error.
            return false
        }
        
        itemProvider.loadDataRepresentation(for: .propertyList) { [weak self] data, error in
            guard let data = data,
                  error == nil else {
                print(error)
                // TODO: Error.
                return
            }
            
            let decoder = PropertyListDecoder()
            guard let webSearches = try? decoder.decode([WebSearch].self, from: data) else {
                // TODO: Decoding error.
                return
            }
            
            DispatchQueue.main.async { [weak self] in
                self?.presentWebSearchSelection(webSearches: webSearches)
            }
        }
        
        return true
    }
    
    func dropEntered(info: DropInfo) {
        isDropItemWithinBounds = true
    }
    
    func dropExited(info: DropInfo) {
        isDropItemWithinBounds = false
    }
}
