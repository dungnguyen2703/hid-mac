import Foundation
import AppKit

public protocol Trigger {
    func isTrigger(key: KeyID?, button: MouseButton?) -> Bool
}

public struct AnyTrigger: Decodable {
    public let trigger: Trigger
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        
        switch typeString.lowercased() {
        case "key":
            trigger = try KeyTrigger(from: decoder)
        case "mouse":
            trigger = try MiceTrigger(from: decoder)
        default:
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown trigger type: \(typeString)")
        }
    }
}

public struct KeyTrigger: Trigger, Decodable {
    public let key: KeyID
    
    enum CodingKeys: String, CodingKey {
        case key
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let keyName = try container.decode(String.self, forKey: .key)
        guard let keyID = KeyID(name: keyName) else {
            throw DecodingError.dataCorruptedError(forKey: .key, in: container, debugDescription: "Invalid key name: \(keyName)")
        }
        self.key = keyID
    }
    
    public func isTrigger(key: KeyID?, button: MouseButton?) -> Bool {
        let isPressed = KeyboardState.isPressed(self.key)
        return self.key == key || isPressed
    }
}


public struct MiceTrigger: Trigger, Decodable {
    public let button: MouseButton
    
    enum CodingKeys: String, CodingKey {
        case button
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let buttonName = try container.decode(String.self, forKey: .button)
        switch buttonName.lowercased() {
        case "left": self.button = .leftButton
        case "right": self.button = .rightButton
        case "middle": self.button = .middleButton
        case "back": self.button = .backButton
        case "forward": self.button = .forwardButton
        default:
            throw DecodingError.dataCorruptedError(forKey: .button, in: container, debugDescription: "Invalid mouse button: \(buttonName)")
        }
    }
    
    public func isTrigger(key: KeyID?, button: MouseButton?) -> Bool {
        return self.button == button || MouseState.isPressed(self.button)
    }
}
