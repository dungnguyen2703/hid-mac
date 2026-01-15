import Foundation
import AppKit


public func parseKeyboardEvent(type: CGEventType, event: CGEvent) -> (KeyID, KeyAction) {
    let keycode = event.getIntegerValueField(.keyboardEventKeycode)
    let flags = event.flags
    var chars: String? = nil
    if type == .keyDown || type == .keyUp {
        let ns = NSEvent(cgEvent: event)
        chars = ns?.charactersIgnoringModifiers
    }
    let mapped = mapKeycode(keycode, chars: chars)
    switch type {
        
    case .keyDown:
        return (mapped, .tapDown)
    case .keyUp:
        return (mapped, .tapUp)
    case .flagsChanged:
        print("FlagsChanged keycode=\(keycode) flags=\(flags) -> \(mapped)")
        return (mapped, .modifierChanged)

    default:
        return (.none, .none)
    }

}

private func mapKeycode(_ code: Int64, chars: String?) -> KeyID {
    if let str = chars , let result = mapCharToKeyID(str){
        print("Day ne \(result)")
        return result
    }
    // Media keys
    switch code {
    
    default: break
    }


    switch code {
    // Letters (ANSI) - Fallback if char mapping failed
    case 0: return .A
    case 11: return .B
    case 8: return .C
    case 2: return .D
    case 14: return .E
    case 3: return .F
    case 5: return .G
    case 4: return .H
    case 34: return .I
    case 38: return .J
    case 40: return .K
    case 37: return .L
    case 46: return .M
    case 45: return .N
    case 31: return .O
    case 35: return .P
    case 12: return .Q
    case 15: return .R
    case 1: return .S
    case 17: return .T
    case 32: return .U
    case 9: return .V
    case 13: return .W
    case 7: return .X
    case 16: return .Y
    case 6: return .Z

    // Number row
    case 29: return .N0
    case 18: return .N1
    case 19: return .N2
    case 20: return .N3
    case 21: return .N4
    case 23: return .N5
    case 22: return .N6
    case 26: return .N7
    case 28: return .N8
    case 25: return .N9

    // Symbols main row
    case 27: return .minus
    case 24: return .equal
    case 33: return .leftBracket
    case 30: return .rightBracket
    case 42: return .backslash
    case 41: return .semicolon
    case 39: return .quote
    case 43: return .comma
    case 47: return .period
    case 44: return .slash
    case 50: return .grave

    // Control and navigation
    case 53: return .escape
    case 48: return .tab
    case 57: return .capsLock
    case 49: return .space
    case 36: return .returnKey
    case 51: return .deleteBackspace
    case 117: return .forwardDelete
    case 115: return .home
    case 119: return .end
    case 116: return .pageUp
    case 121: return .pageDown
    case 114: return .help

    case 123: return .arrowLeft
    case 124: return .arrowRight
    case 125: return .arrowDown
    case 126: return .arrowUp

    // Modifiers (flagsChanged)
    case 56: return .shiftLeft
    case 60: return .shiftRight
    case 59: return .controlLeft
    case 62: return .controlRight
    case 58: return .optionLeft
    case 61: return .optionRight
    case 55: return .commandLeft
    case 54: return .commandRight
    case 63: return .fn

    // Numpad
    case 82: return .Num0
    case 83: return .Num1
    case 84: return .Num2
    case 85: return .Num3
    case 86: return .Num4
    case 87: return .Num5
    case 88: return .Num6
    case 89: return .Num7
    case 91: return .Num8
    case 92: return .Num9
    case 75: return .NumDivide
    case 67: return .NumMultiply
    case 78: return .NumMinus
    case 69: return .NumPlus
    case 76: return .NumEnter
    case 65: return .NumDecimal
    case 81: return .NumEqual
    case 71: return .NumLock

    // Function keys
    case 122: return .F1
    case 120: return .F2
    case 99: return .F3
    case 118: return .F4
    case 96: return .F5
    case 97: return .F6
    case 98: return .F7
    case 100: return .F8
    case 101: return .F9
    case 109: return .F10
    case 103: return .F11
    case 111: return .F12
    
    case 72: return .volumeUp
    case 73: return .volumeDown
    case 74: return .mute
        
    default: return .none
    }
}

private func mapCharToKeyID(_ string: String) -> KeyID? {
    guard string.count == 1 else { return nil }
    let lower = string.lowercased()
    
    // Letters
    switch lower {
    case "a": return .A
    case "b": return .B
    case "c": return .C
    case "d": return .D
    case "e": return .E
    case "f": return .F
    case "g": return .G
    case "h": return .H
    case "i": return .I
    case "j": return .J
    case "k": return .K
    case "l": return .L
    case "m": return .M
    case "n": return .N
    case "o": return .O
    case "p": return .P
    case "q": return .Q
    case "r": return .R
    case "s": return .S
    case "t": return .T
    case "u": return .U
    case "v": return .V
    case "w": return .W
    case "x": return .X
    case "y": return .Y
    case "z": return .Z
    default: break
    }
    
    // Numbers (Main row assumption for generic mapping)
    switch string {
    case "0": return .N0
    case "1": return .N1
    case "2": return .N2
    case "3": return .N3
    case "4": return .N4
    case "5": return .N5
    case "6": return .N6
    case "7": return .N7
    case "8": return .N8
    case "9": return .N9
    default: break
    }
    
    // Symbols
    switch string {
    case "-", "_": return .minus
    case "=", "+": return .equal
    case "[", "{": return .leftBracket
    case "]", "}": return .rightBracket
    case "\\", "|": return .backslash
    case ";", ":": return .semicolon
    case "'", "\"": return .quote
    case ",", "<": return .comma
    case ".", ">": return .period
    case "/", "?": return .slash
    case "`", "~": return .grave
    case " ": return .space
    default: return nil
    }
}
