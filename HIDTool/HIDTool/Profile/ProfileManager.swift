import Foundation
import Combine
import AppKit

public class ProfileManager: ObservableObject {
    public static let shared = ProfileManager()
    
    @Published public var activeProfile: Profile?
    @Published public var availableProfiles: [Profile] = []
    
    private init() {
        // Automatically load profiles on init
        loadAllProfiles()
    }
    
    // MARK: - Loading Logic
    
    public func loadAllProfiles() {
        availableProfiles.removeAll()
        
        // 1. Define paths to search
        let paths = getSearchPaths()
        
        for path in paths {
             print("Scanning for profiles in: \(path.path)")
            loadProfiles(at: path)
        }
        
        // Default to the first loaded profile if any, or specific default
        if activeProfile == nil {
             activeProfile = availableProfiles.first
        }
    }
    
    private func getSearchPaths() -> [URL] {
        var paths: [URL] = []
        
        // Option 1: Beside the App (Portable / User request)
        // If running as .app bundle: /.../Folder/HIDTool.app/ -> /.../Folder/profiles/
        let bundleURL = Bundle.main.bundleURL
        let appFolder = bundleURL.deletingLastPathComponent()
        let localProfiles = appFolder.appendingPathComponent("profiles")
        paths.append(localProfiles)
        
        // Option 2: Standard Application Support
        // ~/Library/Application Support/HIDTool/profiles/
        if let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let appSupportProfiles = appSupport.appendingPathComponent("HIDTool/profiles")
            paths.append(appSupportProfiles)
        }
        
        // Option 3: Documents Folder (User request)
        // ~/Documents/HIDTool/profiles/
        if let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let docProfiles = docs.appendingPathComponent("HIDTool/profiles")
            paths.append(docProfiles)
        }

        // Option 4: User Home config (Dev style)
        // ~/.hidtool/profiles/
        let homeWrapper = FileManager.default.homeDirectoryForCurrentUser
        let dotConfig = homeWrapper.appendingPathComponent(".hidtool/profiles")
        paths.append(dotConfig)
        
        return paths
    }
    
    private func loadProfiles(at directory: URL) {
        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil) else {
            return
        }
        
        let jsonFiles = files.filter { $0.pathExtension == "json" }
        
        for url in jsonFiles {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let profile = try decoder.decode(ProfileImpl.self, from: data)
                
                // Add or Replace if ID exists
                if let idx = availableProfiles.firstIndex(where: { $0.id == profile.id }) {
                    availableProfiles[idx] = profile
                } else {
                    availableProfiles.append(profile)
                }
                print("Loaded Profile: \(profile.name) from \(url.lastPathComponent)")
            } catch {
                print("Error loading profile at \(url.lastPathComponent): \(error)")
            }
        }
    }
    
    public func activateProfile(id: String) {
        if let found = availableProfiles.first(where: { $0.id == id }) {
            self.activeProfile = found
            print("Activated profile: \(found.name)")
        } else if id == "Off" {
            self.activeProfile = nil
             print("Profile Deactivated")
        }
    }
    
    public func handleEvent(key: KeyID?, button: MouseButton?) -> Bool {
        guard let profile = activeProfile else { return false }
        
        if let binding = profile.getBinding(key: key, button: button) {
            print("Binding triggered from profile [\(profile.name)] \(binding)")
            binding.action()
            return binding.disableLatestInput()
        }
        
        return false
    }
}

