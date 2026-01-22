import Foundation
import AppKit

public class MouseState {
    public static var pressedButtons: Set<MouseButton> = []
    
    public static func isPressed(_ button: MouseButton) -> Bool {
        return pressedButtons.contains(button)
    }
}

public func parseMouseEvent(type: CGEventType, event: CGEvent) -> (MouseButton, MouseAction) {
    var button: MouseButton = .none
    var action: MouseAction = .none
    
    switch type {
    case .leftMouseDown:
        button = .leftButton; action = .clickDown
    case .leftMouseUp:
        button = .leftButton; action = .clickUp
    case .rightMouseDown:
        button = .rightButton; action = .clickDown
    case .rightMouseUp:
        button = .rightButton; action = .clickUp
    case .otherMouseDown:
        let btnNum = event.getIntegerValueField(.mouseEventButtonNumber)
        if btnNum == 2 { button = .middleButton }
        else if btnNum == 3 { button = .backButton }
        else if btnNum == 4 { button = .forwardButton }
        else { button = .none }
        action = .clickDown
    case .otherMouseUp:
        let btnNum = event.getIntegerValueField(.mouseEventButtonNumber)
        if btnNum == 2 { button = .middleButton }
        else if btnNum == 3 { button = .backButton }
        else if btnNum == 4 { button = .forwardButton }
        else { button = .none }
        action = .clickUp
    case .scrollWheel:
        let dy = event.getDoubleValueField(.scrollWheelEventDeltaAxis1)
        let dx = event.getDoubleValueField(.scrollWheelEventDeltaAxis2)
        if abs(dy) >= abs(dx) {
            if dy > 0 { button = .scrollWheel; action = .scrollUp }
            if dy < 0 { button = .scrollWheel; action = .scrollDown }
        } else {
            if dx > 0 { button = .scrollWheel; action = .scrollRight }
            if dx < 0 { button = .scrollWheel; action = .scrollLeft }
        }
        if action == .none { button = .scrollWheel; action = .none }
        
    default:
         return (.none, .none)
    }
    
    // Update State
    if action == .clickDown {
        MouseState.pressedButtons.insert(button)
    } else if action == .clickUp {
        MouseState.pressedButtons.remove(button)
    }
    
    return (button, action)
}

