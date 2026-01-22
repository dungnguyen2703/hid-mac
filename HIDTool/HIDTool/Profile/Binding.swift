import Foundation

public protocol Binding {
    func action()
    func disableLatestInput() -> Bool
    func isTrigger(key: KeyID?, button: MouseButton?) -> Bool
}

public struct BindingMapping: Binding, Decodable {
    public let triggers: [Trigger]
    public let actions: [Action]
    public let disabledLatestInput: Bool
    
    enum CodingKeys: String, CodingKey {
        case triggers
        case actions
        case disabledLatestInput = "disabled_latest_input"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // Decode Triggers
        let anyTriggers = try container.decode([AnyTrigger].self, forKey: .triggers)
        self.triggers = anyTriggers.map { $0.trigger }
        
        // Decode Actions
        let anyActions = try container.decode([AnyAction].self, forKey: .actions)
        self.actions = anyActions.map { $0.action }
        
        self.disabledLatestInput = try container.decodeIfPresent(Bool.self, forKey: .disabledLatestInput) ?? false
    }
    
    public func action() {
        for act in actions {
            act.run()
        }
    }
    
    public func disableLatestInput() -> Bool {
        return disabledLatestInput
    }
    
    public func isTrigger(key: KeyID?, button: MouseButton?) -> Bool {
        if triggers.isEmpty { return false }
        
        for trigger in triggers {
            if !trigger.isTrigger(key: key, button: button) {
                return false
            }
        }
        return true
    }
}
