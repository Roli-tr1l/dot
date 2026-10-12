import Foundation
import AppKit
import SwiftUI

public class FloatingPanel: NSPanel {
    public override var canBecomeKey: Bool {
        return true
    }

    public override var canBecomeMain: Bool {
        return true
    }
}

@MainActor
public class WindowController: ObservableObject {
    public static let shared = WindowController()

    public private(set) var panel: FloatingPanel?

    private init() {}

    public func setup() {
        let panel = FloatingPanel(
            contentRect: NSRect(x: 0, y: 0, width: 580, height: 580),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )

        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isReleasedWhenClosed = false
        panel.hidesOnDeactivate = false

        let hostingView = NSHostingView(rootView: OverlayContainerView())
        hostingView.wantsLayer = true
        hostingView.layer?.contentsScale = NSScreen.main?.backingScaleFactor ?? 2.0

        panel.contentView = hostingView

        // Position on the right side of primary screen
        if let screen = NSScreen.main {
            let visibleRect = screen.visibleFrame
            let initialX = round(visibleRect.maxX - 600)
            let initialY = round(visibleRect.minY + 80)
            panel.setFrameOrigin(NSPoint(x: initialX, y: initialY))
        }

        panel.orderFrontRegardless()
        self.panel = panel
    }

    public func toggleVisibility() {
        guard let panel = panel else { return }
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            panel.orderFrontRegardless()
        }
    }

    public func showPanel() {
        panel?.orderFrontRegardless()
    }
}
