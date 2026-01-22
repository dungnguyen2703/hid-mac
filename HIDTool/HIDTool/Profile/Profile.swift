import Foundation

public protocol Profile {
    var id: String { get }
    var name: String { get }
    var description: String { get }
    func getBinding(key: KeyID?, button: MouseButton?) -> Binding?
}

public struct ProfileImpl: Profile, Decodable {
    public let id: String
    public let name: String
    public let description: String
    public var bindings: [Binding]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case bindings
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(String.self, forKey: .id) ?? UUID().uuidString
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        
        var bindingsArray: [Binding] = []
        if container.contains(.bindings) {
            var bindingsUnkeyed = try container.nestedUnkeyedContainer(forKey: .bindings)
            while !bindingsUnkeyed.isAtEnd {
                // Try to decode as BindingMapping (since it's the only one for now)
                // In Go, it checks "type" field. Here we can peek or just assume default.
                // For robustness, we could use a wrapper similar to AnyAction
                let binding = try bindingsUnkeyed.decode(BindingMapping.self)
                bindingsArray.append(binding)
            }
        }
        self.bindings = bindingsArray
    }
    
    public func getBinding(key: KeyID?, button: MouseButton?) -> Binding? {
        if key == nil && button == nil { return nil }
        
        for binding in bindings {
            if binding.isTrigger(key: key, button: button) {
                return binding
            }
        }
        return nil
    }
}
