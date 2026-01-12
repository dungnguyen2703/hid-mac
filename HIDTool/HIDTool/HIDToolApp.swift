import SwiftUI

@main
struct HIDToolApp: App {
    // Biến lưu trạng thái Profile hiện tại
    @State private var currentProfile = "Mice + Keyboard"
    
    // Khởi tạo một "Manager" để bắt sự kiện (chúng ta sẽ viết ở Bước 2)
    @StateObject private var hidManager = HIDManager()

    var body: some Scene {
        // Thay WindowGroup bằng MenuBarExtra để hiện icon trên thanh sớ
        MenuBarExtra {
            // Danh sách Menu y hệt bản Windows
            Button(currentProfile == "Off" ? "✓ Off" : "Off") { selectProfile("Off") }
            Button(currentProfile == "Mice + Keyboard" ? "✓ Mice + Keyboard" : "Mice + Keyboard") { selectProfile("Mice + Keyboard") }
            Button(currentProfile == "Keyboard Only" ? "✓ Keyboard Only" : "Keyboard Only") { selectProfile("Keyboard Only") }
            Button(currentProfile == "Mice Only" ? "✓ Mice Only" : "Mice Only") { selectProfile("Mice Only") }
            
            Divider()
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        } label: {
            // Icon hiển thị trên thanh Menu (Bạn có thể dùng hình con chuột)
//            Image(systemName: "mouse")
        }
    }
    
    func selectProfile(_ name: String) {
        currentProfile = name
        hidManager.updateProfile(name) // Báo cho Manager biết để đổi logic bắt phím
    }
}
