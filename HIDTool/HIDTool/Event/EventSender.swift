import Foundation
import AppKit

public class EventSender {
    
    public static func postKeyDown(_ key: KeyID) {
        guard let keyCode = keyCode(from: key) else { return }
        postEvent(keyCode: keyCode, keyDown: true)
    }
    
    public static func postKeyUp(_ key: KeyID) {
        guard let keyCode = keyCode(from: key) else { return }
        postEvent(keyCode: keyCode, keyDown: false)
    }
    
    public static func press(_ key: KeyID) {
        postKeyDown(key)
        postKeyUp(key)
    }
    
    private static func postEvent(keyCode: CGKeyCode, keyDown: Bool) {
        print("postEvent \(keyCode), \(keyDown)")
        let source = CGEventSource(stateID: .hidSystemState)
        let event = CGEvent(keyboardEventSource: source, virtualKey: keyCode, keyDown: keyDown)
        event?.post(tap: .cghidEventTap)
    }
    
    private static func keyCode(from key: KeyID) -> CGKeyCode? {
        switch key {
        case .A: return 0x00
        case .S: return 0x01
        case .D: return 0x02
        case .F: return 0x03
        case .H: return 0x04
        case .G: return 0x05
        case .Z: return 0x06
        case .X: return 0x07
        case .C: return 0x08
        case .V: return 0x09
        case .B: return 0x0B
        case .Q: return 0x0C
        case .W: return 0x0D
        case .E: return 0x0E
        case .R: return 0x0F
        case .Y: return 0x10
        case .T: return 0x11
        case .N1: return 0x12
        case .N2: return 0x13
        case .N3: return 0x14
        case .N4: return 0x15
        case .N6: return 0x16
        case .N5: return 0x17
        case .equal: return 0x18
        case .N9: return 0x19
        case .N7: return 0x1A
        case .minus: return 0x1B
        case .N8: return 0x1C
        case .N0: return 0x1D
        case .rightBracket: return 0x1E
        case .O: return 0x1F
        case .U: return 0x20
        case .leftBracket: return 0x21
        case .I: return 0x22
        case .P: return 0x23
        case .returnKey: return 0x24
        case .L: return 0x25
        case .J: return 0x26
        case .quote: return 0x27
        case .K: return 0x28
        case .semicolon: return 0x29
        case .backslash: return 0x2A
        case .comma: return 0x2B
        case .slash: return 0x2C
        case .N: return 0x2D
        case .M: return 0x2E
        case .period: return 0x2F
        case .tab: return 0x30
        case .space: return 0x31
        case .grave: return 0x32
        case .deleteBackspace: return 0x33
        case .escape: return 0x35
        case .commandRight: return 0x36 // Approximate
        case .commandLeft: return 0x37
        case .shiftLeft: return 0x38
        case .capsLock: return 0x39
        case .optionLeft: return 0x3A
        case .controlLeft: return 0x3B
        case .shiftRight: return 0x3C
        case .optionRight: return 0x3D
        case .controlRight: return 0x3E
        case .fn: return 0x3F
//      case .decimal: return 0x41
//      case .multiply: return 0x43
//      case .plus: return 0x45
//      case .clear: return 0x47
//      case .divide: return 0x4B
//      case .enter: return 0x4C
//      case .minus: return 0x4E
//      case .equals: return 0x51
//      case .0: return 0x52
//      case .1: return 0x53
//      case .2: return 0x54
//      case .3: return 0x55
//      case .4: return 0x56
//      case .5: return 0x57
//      case .6: return 0x58
//      case .7: return 0x59
//      case .F5: return 0x60
//      case .F6: return 0x61
//      case .F7: return 0x62
//      case .F3: return 0x63
//      case .F8: return 0x64
//      case .F9: return 0x65
//      case .F11: return 0x67
//      case .F13: return 0x69
//      case .F14: return 0x6B
//      case .F10: return 0x6D
//      case .F12: return 0x6F
//      case .F15: return 0x71
//      case .help: return 0x72
//      case .home: return 0x73
//      case .pageUp: return 0x74
//      case .forwardDelete: return 0x75
//      case .F4: return 0x76
//      case .end: return 0x77
//      case .F2: return 0x78
//      case .pageDown: return 0x79
//      case .F1: return 0x7A
        case .arrowLeft: return 123
        case .arrowRight: return 124
        case .arrowDown: return 125
        case .arrowUp: return 126
        default: return nil
        }
    }
}
