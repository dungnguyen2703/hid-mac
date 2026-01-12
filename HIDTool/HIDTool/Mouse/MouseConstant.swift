public enum MouseButton: Equatable {
    case leftButton
    case rightButton
    case middleButton
    case backButton
    case forwardButton
    case scrollWheel
    case other(Int64)
    case none
}

public enum MouseAction {
    case clickDown
    case clickUp
    case scrollUp
    case scrollDown
    case scrollLeft
    case scrollRight
    case none
}
