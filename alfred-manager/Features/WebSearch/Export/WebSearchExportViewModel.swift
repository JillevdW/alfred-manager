//
//  WebSearchExportViewModel.swift
//  alfred-manager
//
//  Created by Jille van der Weerd on 26/12/2022.
//

import Factory
import Foundation
import Cocoa

struct WebSearchPrefs: Codable {
    let customSites: [String: WebSearch]
}

struct WebSearch: Codable, Hashable {
    let keyword: String
    let text: String
    let url: String
    let utf8: Bool
    let enabled: Bool
}

class WebSearchExportViewModel: ViewModel {
    @Injected(RootViewContainer.preferencesManager) var preferencesManager
    @Published private (set) var webSearches: [WebSearch] = []
    @Published var selection: [WebSearch] = []
    
    private var webSearchPath: URL?
    private var exportLocation: URL?
    
    override func onCreate() {
        super.onCreate()
        
        webSearchPath = preferencesManager.alfredInstallationPath?
            .appendingPathComponent("Alfred.alfredpreferences", conformingTo: .folder)
            .appendingPathComponent("preferences", conformingTo: .folder)
            .appendingPathComponent("features", conformingTo: .folder)
            .appendingPathComponent("websearch", conformingTo: .folder)
            .appendingPathComponent("prefs", conformingTo: .propertyList)
        
        loadPreferences()
    }
    
    private func loadPreferences() {
        guard let webSearchPath else {
            // Emit error state.
            return
        }
        
        let decoder = PropertyListDecoder()
        guard let data = try? Data.init(contentsOf: webSearchPath),
              let webSearchPrefs = try? decoder.decode(WebSearchPrefs.self, from: data) else {
            // Emit error state.
            return
        }
        
        webSearches = webSearchPrefs.customSites.map( { $0.value })
        selection = webSearches
    }
    
    // MARK: - Selection
    
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
    
    // MARK: - Export
    
    func selectExportLocation() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [.propertyList]
        panel.nameFieldStringValue = "alfred-export"
        
        // TODO: Explicit handling of cancel and other unsupported states.
        if panel.runModal() == .OK {
            exportLocation = panel.url
        }
        
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        guard let exportLocation = self.exportLocation,
              let data = try? encoder.encode(selection) else {
            // TODO: Error message for export.
            return
        }
        
        do {
            try data.write(to: exportLocation)
            // TODO: Success message for export.
        } catch {
            print(error)
            // TODO: Error message for export.
        }
    }
}
