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
                let anyBinding = try bindingsUnkeyed.decode(AnyBinding.self)
                bindingsArray.append(anyBinding.binding)
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
