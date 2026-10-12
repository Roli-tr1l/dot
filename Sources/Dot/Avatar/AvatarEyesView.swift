import Foundation
import SwiftUI
import AppKit

public struct AvatarEyesView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var anim: AvatarAnimationState = AvatarAnimationState.shared

    let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    private var eyeSize: CGFloat {
        diameter * 0.22
    }

    private var eyeSpacing: CGFloat {
        diameter * 0.26
    }

    public var body: some View {
        HStack(spacing: eyeSpacing) {
            singleEyeView(isLeft: true)
            singleEyeView(isLeft: false)
        }
        .onAppear {
            anim.startBlinkLoop()
        }
        .onDisappear {
            anim.stopBlinkLoop()
        }
        .onChange(of: state.mood) { newMood in
            anim.updatePupil(for: newMood, eyeSize: eyeSize)
        }
    }

    @ViewBuilder
    private func singleEyeView(isLeft: Bool) -> some View {
        ZStack {
            switch state.mood {
            case .happy:
                // Joyful arch eyes: ^
                HappyArchShape()
                    .stroke(Color.white, style: StrokeStyle(lineWidth: eyeSize * 0.28, lineCap: .round))
                    .frame(width: eyeSize, height: eyeSize * 0.7)

            case .sleeping:
                // Peaceful closed eyelids: -
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.white.opacity(0.85))
                    .frame(width: eyeSize, height: eyeSize * 0.18)

            default:
                // Normal / Thinking / Attentive eye with tracking pupil & highlights
                ZStack {
                    // Sclera (White base)
                    Circle()
                        .fill(Color.white)
                        .frame(width: eyeSize, height: eyeSize)
                        .shadow(color: Color.black.opacity(0.15), radius: 1, x: 0, y: 1)

                    // Pupil
                    Circle()
                        .fill(Color(red: 0.1, green: 0.12, blue: 0.18))
                        .frame(width: eyeSize * 0.62, height: eyeSize * 0.62)
                        .offset(anim.pupilOffset)

                    // Secondary Iris glow
                    Circle()
                        .fill(config.colorTheme.primaryColor.opacity(0.7))
                        .frame(width: eyeSize * 0.35, height: eyeSize * 0.35)
                        .offset(anim.pupilOffset)

                    // Glossy specular highlight
                    Circle()
                        .fill(Color.white)
                        .frame(width: eyeSize * 0.22, height: eyeSize * 0.22)
                        .offset(x: anim.pupilOffset.width - eyeSize * 0.12, y: anim.pupilOffset.height - eyeSize * 0.12)

                    // Tiny secondary sparkle
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .frame(width: eyeSize * 0.11, height: eyeSize * 0.11)
                        .offset(x: anim.pupilOffset.width + eyeSize * 0.1, y: anim.pupilOffset.height + eyeSize * 0.1)
                }
                .scaleEffect(y: anim.isBlinking ? 0.08 : 1.0, anchor: .center)
                .animation(.easeInOut(duration: 0.1), value: anim.isBlinking)
            }
        }
    }
}

// Custom Shape for Happy Eye Arc
struct HappyArchShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY - rect.height * 0.3)
        )
        return path
    }
}
