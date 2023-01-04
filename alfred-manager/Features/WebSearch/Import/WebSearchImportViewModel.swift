//
//  WebSearchImportViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 29/12/2022.
//

import Foundation
import SwiftUI
import Factory
import Cocoa

extension WebSearchImportViewModel {
    enum StatusMessage {
        case error(LocalizedStringKey)
        case success(LocalizedStringKey)
    }
}

class WebSearchImportViewModel: ViewModel {
    @Injected(RootViewContainer.preferencesManager) private var preferencesManager
    @Injected(WebSearchImportContainer.logger) private var logger
    
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
    
    func importSelection() {
        guard let webSearchPreferences = loadCurrentPreferences() else {
            logger.error("Error when importing selection: current preferences could not be loaded.")
            return
        }
        
        var customSites = webSearchPreferences.customSites
        
        selection.forEach { webSearch in
            customSites[UUID().uuidString] = webSearch
        }
        
        let newWebSearchPrefs = WebSearchPrefs(customSites: customSites)
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let exportLocation = webSearchPath else {
            logger.error("Error when importing selection: webSearchPath is nil.")
            return
        }

        do {
            let data = try encoder.encode(newWebSearchPrefs)
            try data.write(to: exportLocation)
            showSuccessStatusMessage()
            resetWebSearchSelection()
        } catch {
            logger.error("Error when importing selection: \(error.localizedDescription, privacy: .public)")
            showErrorStatusMessage(error: error)
        }
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
        self.isShowingSelectionScreen = false
    }
    
    // MARK: - Private Current Websearch loading
    
    private func loadCurrentPreferences() -> WebSearchPrefs? {
        guard let webSearchPath = webSearchPath else {
            logger.error("Error when loading current preferences: webSearchPath is nil.")
            return nil
        }
        
        let decoder = PropertyListDecoder()
        do {
            let data = try Data.init(contentsOf: webSearchPath)
            return try decoder.decode(WebSearchPrefs.self, from: data)
        } catch {
            logger.error("Error when loading current preferences: \(error.localizedDescription, privacy: .public)")
            return nil
        }
    }
    
    private var webSearchPath: URL? {
        preferencesManager.alfredInstallationPath?
            .appendingPathComponent("Alfred.alfredpreferences", conformingTo: .folder)
            .appendingPathComponent("preferences", conformingTo: .folder)
            .appendingPathComponent("features", conformingTo: .folder)
            .appendingPathComponent("websearch", conformingTo: .folder)
            .appendingPathComponent("prefs", conformingTo: .propertyList)
    }
    
    private func showSuccessStatusMessage() {
        let text: String
        if selection.count == 1 {
            text = "Successfully imported 1 Web Search."
        } else {
            text = "Successfully imported \(selection.count) Web Searches."
        }
        let alert = NSAlert()
        alert.messageText = text
        alert.runModal()
    }
    
    private func showErrorStatusMessage(error: Error?) {
        let text: String
        if let error {
            text = "Something went wrong: \(error.localizedDescription)"
        } else {
            text = "Something went wrong."
        }
        let alert = NSAlert()
        alert.messageText = text
        alert.runModal()
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
