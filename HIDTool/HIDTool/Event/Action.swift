import Foundation

public protocol Action {
    func run()
}

public enum ActionType: String, Codable {
    case windowLeft = "window_left"
    case windowRight = "window_right"
    case tapDown = "tap_down"
    case tapUp = "tap_up"
    case press = "press"
    case delay = "delay"
}

public struct AnyAction: Decodable {
    public let action: Action
    
    enum CodingKeys: String, CodingKey {
        case type
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeString = try container.decode(String.self, forKey: .type)
        
        guard let type = ActionType(rawValue: typeString) else {
            throw DecodingError.dataCorruptedError(forKey: .type, in: container, debugDescription: "Unknown action type: \(typeString)")
        }
        
        switch type {
        case .windowLeft:
            action = try WindowLeft(from: decoder)
        case .windowRight:
            action = try WindowRight(from: decoder)
        case .tapDown:
            action = try TapDown(from: decoder)
        case .tapUp:
            action = try TapUp(from: decoder)
        case .press:
            action = try Press(from: decoder)
        case .delay:
            action = try Delay(from: decoder)
        }
    }
}

// --- Press Action ---
public struct Press: Action, Decodable {
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
    
    public func run() {
        EventSender.press(key)
    }
}

// --- TapDown Action ---
public struct TapDown: Action, Decodable {
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
    
    public func run() {
        EventSender.postKeyDown(key)
    }
}

// --- TapUp Action ---
public struct TapUp: Action, Decodable {
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
    
    public func run() {
        EventSender.postKeyUp(key)
    }
}

// --- Delay Action ---
public struct Delay: Action, Decodable {
    public let duration: Int // Milliseconds
    
    enum CodingKeys: String, CodingKey {
        case duration
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.duration = try container.decode(Int.self, forKey: .duration)
    }
    
    public func run() {
        usleep(useconds_t(duration * 1000))
    }
}

// --- WindowLeft Action ---
public struct WindowLeft: Action, Decodable {
    public func run() {
        EventSender.postKeyDown(.controlLeft)
        EventSender.postKeyDown(.arrowLeft)
        EventSender.postKeyUp(.arrowLeft)
        EventSender.postKeyUp(.controlLeft)
    }
}

// --- WindowRight Action ---
public struct WindowRight: Action, Decodable {
    public func run() {
        EventSender.postKeyDown(.controlLeft)
        EventSender.postKeyDown(.arrowRight)
        EventSender.postKeyUp(.arrowRight)
        EventSender.postKeyUp(.controlLeft)
    }
}

// MARK: - KeyID Extension for String Parsing
extension KeyID {
    // Simple helper to match string names from JSON to KeyID cases
    init?(name: String) {
        switch name.lowercased() {
        case "a": self = .A
        case "b": self = .B
        case "c": self = .C
        case "d": self = .D
        case "e": self = .E
        case "f": self = .F
        case "g": self = .G
        case "h": self = .H
        case "i": self = .I
        case "j": self = .J
        case "k": self = .K
        case "l": self = .L
        case "m": self = .M
        case "n": self = .N
        case "o": self = .O
        case "p": self = .P
        case "q": self = .Q
        case "r": self = .R
        case "s": self = .S
        case "t": self = .T
        case "u": self = .U
        case "v": self = .V
        case "w": self = .W
        case "x": self = .X
        case "y": self = .Y
        case "z": self = .Z
        case "ctrl", "control": self = .controlLeft
        case "shift": self = .shiftLeft
        case "alt", "option": self = .optionLeft
        case "cmd", "command", "win": self = .commandLeft
        case "enter", "return": self = .returnKey
        case "space": self = .space
        case "tab": self = .tab
        case "esc", "escape": self = .escape
        case "arrowleft", "left": self = .arrowLeft
        case "arrowright", "right": self = .arrowRight
        case "arrowup", "up": self = .arrowUp
        case "arrowdown", "down": self = .arrowDown
        // Add more mappings as needed
        default: return nil
        }
    }
}
