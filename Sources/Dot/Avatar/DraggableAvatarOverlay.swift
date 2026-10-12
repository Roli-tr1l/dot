import Foundation
import AppKit
import SwiftUI

public struct DraggableAvatarOverlay: NSViewRepresentable {
    public init() {}

    public func makeNSView(context: Context) -> DraggableNSView {
        return DraggableNSView()
    }

    public func updateNSView(_ nsView: DraggableNSView, context: Context) {}
}

public class DraggableNSView: NSView {
    private var initialMouseScreenLocation: NSPoint = .zero
    private var initialWindowOrigin: NSPoint = .zero
    private var isDraggingWindow: Bool = false

    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.wantsLayer = true
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func mouseDown(with event: NSEvent) {
        initialMouseScreenLocation = NSEvent.mouseLocation
        if let win = window {
            initialWindowOrigin = win.frame.origin
        }
        isDraggingWindow = false
    }

    public override func mouseDragged(with event: NSEvent) {
        let currentMouse = NSEvent.mouseLocation
        let dx = currentMouse.x - initialMouseScreenLocation.x
        let dy = currentMouse.y - initialMouseScreenLocation.y

        if !isDraggingWindow && (abs(dx) > 2.0 || abs(dy) > 2.0) {
            isDraggingWindow = true
            Task { @MainActor in
                DotState.shared.wakeUp()
                DotState.shared.isDragging = true
            }
        }

        if isDraggingWindow, let win = window {
            let newX = round(initialWindowOrigin.x + dx)
            let newY = round(initialWindowOrigin.y + dy)
            win.setFrameOrigin(NSPoint(x: newX, y: newY))
        }
    }

    public override func mouseUp(with event: NSEvent) {
        if isDraggingWindow {
            isDraggingWindow = false
            Task { @MainActor in
                DotState.shared.isDragging = false
            }
        } else {
            if event.clickCount == 2 {
                Task { @MainActor in
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        DotState.shared.isChatOpen.toggle()
                    }
                    DotState.shared.wakeUp()
                    SpeechService.shared.playPopSound()
                }
            } else {
                Task { @MainActor in
                    AvatarAnimationState.shared.poke()
                    DotState.shared.wakeUp()
                }
            }
        }
    }
}
