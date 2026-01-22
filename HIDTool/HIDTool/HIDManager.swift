import Foundation
import AppKit
import ApplicationServices
import Combine


class HIDManager: ObservableObject {
    @Published var currentStatus: String = "Inactive"
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    init() {
        // Don't start automatically here if you prefer explicit control
        startMonitoring()
    }

    func isAccessibilityTrusted(prompt: Bool = true) -> Bool {
        let options = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: prompt] as CFDictionary
        return AXIsProcessTrustedWithOptions(options)
    }

    func startMonitoring() {
        guard isAccessibilityTrusted(prompt: true) else {
            debugLog("Accessibility permission not granted. Prompted user.")
            return
        }
        currentStatus = "Active"
        let mask =  (1 << CGEventType.keyDown.rawValue) |
                    (1 << CGEventType.keyUp.rawValue) |
                    (1 << CGEventType.flagsChanged.rawValue) |
                    (1 << CGEventType.leftMouseDown.rawValue) |
                    (1 << CGEventType.leftMouseUp.rawValue) |
                    (1 << CGEventType.rightMouseDown.rawValue) |
                    (1 << CGEventType.rightMouseUp.rawValue) |
                    (1 << CGEventType.otherMouseDown.rawValue) |
                    (1 << CGEventType.otherMouseUp.rawValue) |
                    (1 << CGEventType.scrollWheel.rawValue) |
                    (1 << CGEventType.mouseMoved.rawValue)

        guard let tap = CGEvent.tapCreate(
            tap: .cghidEventTap, place: .headInsertEventTap,
            options: .defaultTap,
            eventsOfInterest: CGEventMask(mask),
            callback: {(proxy, type, cgEvent, refcon) -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else { return Unmanaged.passUnretained(cgEvent) }
                let manager = Unmanaged<HIDManager>.fromOpaque(refcon).takeUnretainedValue()
                let shouldSuppress = manager.handleEvent(type: type, event: cgEvent)
                if shouldSuppress {
                    return nil
                }
                return Unmanaged.passUnretained(cgEvent)
            },
            userInfo: UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque()))
        else {
            debugLog("Failed to create event tap. Check Accessibility permission and that the app is not sandboxed.")
            return
        }

        self.eventTap = tap
        self.runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)
        if let src = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), src, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
            debugLog("Event started on runloop.")
        }
    }

    func stopMonitoring() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
            if let src = runLoopSource {
                CFRunLoopRemoveSource(CFRunLoopGetCurrent(), src, .commonModes)
            }
            CFMachPortInvalidate(tap)
            eventTap = nil
            runLoopSource = nil
            currentStatus = "Inactive"
            debugLog("Event stopped.")
        }
    }

    private func debugLog(_ msg: String) {
        let ts = ISO8601DateFormatter().string(from: Date())
        print("[HIDManager] [\(ts)] \(msg)")
    }

    private func handleEvent(type: CGEventType, event: CGEvent) -> Bool {
        var keyID: KeyID? = nil
        var mouseButton: MouseButton? = nil
        
        switch type {
        case .keyDown, .keyUp, .flagsChanged:
            let result = parseKeyboardEvent(type: type, event: event)
            if result.1 == .tapDown || result.1 == .modifierChanged {
                keyID = result.0
            }
            
        case .leftMouseDown, .leftMouseUp, .rightMouseDown, .rightMouseUp, .otherMouseDown, .otherMouseUp, .scrollWheel:
            let result = parseMouseEvent(type: type, event: event)
            if result.1 == .clickDown {
                mouseButton = result.0
            }
            
        default:
            break
        }
        if (keyID == nil && mouseButton == nil) {
            return false
        }
        
        return ProfileManager.shared.handleEvent(key: keyID, button: mouseButton)
    }
    
    func updateProfile(_ name: String) {
        print("Đã chuyển sang Profile: \(name)")
    }
}

