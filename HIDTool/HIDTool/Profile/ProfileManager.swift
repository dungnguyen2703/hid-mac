import Foundation
import Combine

public class ProfileManager: ObservableObject {
    public static let shared = ProfileManager()
    
    @Published public var currentProfile: Profile?
    
    private init() {}
    
    public func loadProfile(json: String) {
        let decoder = JSONDecoder()
        if let data = json.data(using: .utf8) {
            do {
                let profile = try decoder.decode(ProfileImpl.self, from: data)
                self.currentProfile = profile
                print("Loaded profile: \(profile.name)")
            } catch {
                print("Failed to decode profile: \(error)")
            }
        }
    }
    
    public func handleEvent(key: KeyID?, button: MouseButton?) -> Bool {
        guard let profile = currentProfile else { return false }
        
        if let binding = profile.getBinding(key: key, button: button) {
            print("Binding triggered!")
            binding.action()
            return binding.disableLatestInput()
        }
        
        return false
    }
}
