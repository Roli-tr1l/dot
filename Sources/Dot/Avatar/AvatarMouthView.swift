import Foundation
import SwiftUI

public struct AvatarMouthView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var anim: AvatarAnimationState = AvatarAnimationState.shared

    let diameter: CGFloat

    private var mouthWidth: CGFloat {
        diameter * 0.16
    }

    public var body: some View {
        Group {
            switch state.mood {
            case .happy:
                // Big beaming grin
                HappyMouthGrin()
                    .fill(Color(red: 0.15, green: 0.12, blue: 0.2))
                    .frame(width: mouthWidth * 1.3, height: mouthWidth * 0.8)
                    .overlay(
                        // Cute little tongue
                        Circle()
                            .fill(Color(red: 1.0, green: 0.45, blue: 0.6))
                            .frame(width: mouthWidth * 0.7, height: mouthWidth * 0.5)
                            .offset(y: mouthWidth * 0.25)
                            .clipped()
                    )

            case .speaking:
                // Talking pulse
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.15, green: 0.12, blue: 0.2))
                    .frame(width: mouthWidth * 0.9, height: mouthWidth * (0.35 + anim.speakingPulse * 0.25))

            case .thinking:
                // Small thinking 'o'
                Circle()
                    .stroke(Color(red: 0.15, green: 0.12, blue: 0.2), lineWidth: 2.2)
                    .frame(width: mouthWidth * 0.45, height: mouthWidth * 0.45)

            case .sleeping:
                // Tiny peaceful line
                Capsule()
                    .fill(Color(red: 0.15, green: 0.12, blue: 0.2).opacity(0.6))
                    .frame(width: mouthWidth * 0.6, height: 2)

            default:
                // Gentle cute curve smile
                GentleSmileShape()
                    .stroke(Color(red: 0.15, green: 0.12, blue: 0.2), style: StrokeStyle(lineWidth: 2.4, lineCap: .round))
                    .frame(width: mouthWidth, height: mouthWidth * 0.45)
            }
        }
    }
}

struct GentleSmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

struct HappyMouthGrin: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.3)
        )
        path.closeSubpath()
        return path
    }
}
