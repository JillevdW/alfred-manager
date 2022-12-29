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
            .sink { [weak self] isShowingSelectionScreen in
                if !isShowingSelectionScreen {
                    self?.resetWebSearchSelection()
                }
            }.store(in: &lifecycle)
    }
    
    // MARK: - Public API
    
    func selectConfigurationPath() {
        guard let url = configurationPathFromOpenPanel(),
              let data = try? Data.init(contentsOf: url) else {
            // TODO: Error state.
            return
        }
        
        guard let webSearches = decodeWebSearches(from: data) else {
            // TODO: Error state.
            return
        }
        
        presentWebSearchSelection(webSearches: webSearches)
    }
    
    // MARK: - WebSearch Selection
    
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
    
    // MARK: - Private Config selection
    
    private func configurationPathFromOpenPanel() -> URL? {
        let panel = NSOpenPanel()
        panel.directoryURL = .downloadsDirectory
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.treatsFilePackagesAsDirectories = true
        if panel.runModal() == .OK {
            return panel.url
        } else {
            // TODO: Handle error cases.
            return nil
        }
    }
    
    private func decodeWebSearches(from data: Data) -> [WebSearch]? {
        let decoder = PropertyListDecoder()
        return try? decoder.decode([WebSearch].self, from: data)
    }
    
    // MARK: - Private WebSearch Selection
    
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
            
            guard let webSearches = self?.decodeWebSearches(from: data) else {
                // TODO: Error.
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
