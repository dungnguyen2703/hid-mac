public enum KeyID: Equatable {
    // Letters
    case A; case B; case C; case D; case E; case F; case G; case H; case I; case J; case K; case L; case M; case N; case O; case P; case Q; case R; case S; case T; case U; case V; case W; case X; case Y; case Z;
    // Number row
    case N0; case N1; case N2; case N3; case N4; case N5; case N6; case N7; case N8; case N9;
    // Symbols (main row)
    case minus; case equal; case leftBracket; case rightBracket; case backslash; case semicolon; case quote; case comma; case period; case slash; case grave;
    // Numpad
    case Num0; case Num1; case Num2; case Num3; case Num4; case Num5; case Num6; case Num7; case Num8; case Num9;
    case NumDivide; case NumMultiply; case NumMinus; case NumPlus; case NumEnter; case NumDecimal; case NumEqual; case NumLock;
    // Control keys
    case escape; case tab; case capsLock; case shiftLeft; case shiftRight; case controlLeft; case controlRight; case optionLeft; case optionRight; case commandLeft; case commandRight; case fn;
    case space; case enter; case returnKey; case deleteBackspace; case forwardDelete; case home; case end; case pageUp; case pageDown; case insert; case help;
    // Arrows
    case arrowUp; case arrowDown; case arrowLeft; case arrowRight;
    // Function keys
    case F1; case F2; case F3; case F4; case F5; case F6; case F7; case F8; case F9; case F10; case F11; case F12;
    // Media keys
    case volumeUp; case volumeDown; case mute;
    // Other keys
    case printScreen; case scrollLock; case pauseBreak; case application; case power;
    
    case none
}

public enum KeyAction {
    case tapDown
    case tapUp
    case modifierChanged
    case none
}
