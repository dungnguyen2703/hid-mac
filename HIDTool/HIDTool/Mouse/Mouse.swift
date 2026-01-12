import Foundation
import AppKit

public func parseMouseEvent(type: CGEventType, event: CGEvent) -> (MouseButton, MouseAction) {
    switch type {
    case .leftMouseDown:
        return (.leftButton, .clickDown)
    case .leftMouseUp:
        return (.leftButton, .clickUp)
    case .rightMouseDown:
        return (.rightButton, .clickDown)
    case .rightMouseUp:
        return (.rightButton, .clickUp)
    case .otherMouseDown:
        let button = event.getIntegerValueField(.mouseEventButtonNumber)
        if button == 2 {
            return (.middleButton, .clickDown)
        } else if button == 3 {
            return (.backButton, .clickDown)
        } else if button == 4 {
            return (.forwardButton, .clickDown)
        } else {
            return (.other(button), .clickDown)
        }
    case .otherMouseUp:
        let button = event.getIntegerValueField(.mouseEventButtonNumber)
        if button == 2 {
            return (.middleButton, .clickUp)
        } else if button == 3 {
            return (.backButton, .clickUp)
        } else if button == 4 {
            return (.forwardButton, .clickUp)
        } else {
            return (.other(button), .clickUp)
        }
    case .scrollWheel:
        let dy = event.getDoubleValueField(.scrollWheelEventDeltaAxis1)
        let dx = event.getDoubleValueField(.scrollWheelEventDeltaAxis2)
        if abs(dy) >= abs(dx) {
            if dy > 0 { return (.scrollWheel, .scrollUp) }
            if dy < 0 { return (.scrollWheel, .scrollDown) }
        } else {
            if dx > 0 { return (.scrollWheel, .scrollRight) }
            if dx < 0 { return (.scrollWheel, .scrollLeft) }
        }
        return (.scrollWheel, .none)

    default:
        return (.none, .none)
    }

}
