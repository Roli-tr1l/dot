import Foundation
import SwiftUI
import AppKit

public struct DotAvatarView: View {
    @ObservedObject var state: DotState = DotState.shared
    @ObservedObject var config: DotConfig = DotConfig.shared
    @ObservedObject var anim: AvatarAnimationState = AvatarAnimationState.shared

    private var diameter: CGFloat {
        config.size.diameter
    }

    private var bodyWidth: CGFloat {
        switch config.bodyShape {
        case .orb:  return diameter
        case .bean: return diameter * 0.88
        case .drop: return diameter * 0.94
        }
    }

    private var bodyHeight: CGFloat {
        switch config.bodyShape {
        case .orb:  return diameter
        case .bean: return diameter * 1.15
        case .drop: return diameter * 1.08
        }
    }

    public var body: some View {
        ZStack {
            // Background Vector Aura Glow (Zero pixelation / No downsampled GPU blur)
            baseAuraGlow()

            // Thinking Orbital Ring
            if state.mood == .thinking {
                ThinkingOrbitalRing(diameter: diameter)
                    .rotationEffect(.degrees(anim.orbitRotation))
            }

            // Speaking Soundwave Rings
            if state.mood == .speaking {
                Circle()
                    .stroke(config.colorTheme.primaryColor.opacity(0.4), lineWidth: 2)
                    .frame(width: diameter * 1.25 * anim.speakingPulse, height: diameter * 1.25 * anim.speakingPulse)
                    .opacity(2.0 - Double(anim.speakingPulse))
            }

            // Main Mascot Body
            ZStack {
                // Procedural 3D Body Mesh
                mascotBodyShapeView()

                // Top Specular Highlight (Soft Sheen)
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color.white.opacity(0.55), Color.white.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: bodyWidth * 0.52, height: bodyHeight * 0.26)
                    .offset(x: -bodyWidth * 0.08, y: -bodyHeight * 0.28)

                // Cheeks / Blush
                if state.mood != .sleeping {
                    blushCheeksView()
                }

                // Eyes
                AvatarEyesView(diameter: diameter)
                    .offset(y: -bodyHeight * 0.04)

                // Animated Mouth
                AvatarMouthView(diameter: diameter)
                    .offset(y: bodyHeight * 0.14)

                // Accessories (Glasses, Hats, Sprout, Beret, Bowtie, Headphones)
                AccessoriesView(diameter: diameter)
                    .offset(y: -bodyHeight * 0.04)
            }
            .scaleEffect(x: anim.squishScaleX, y: anim.squishScaleY)
            .scaleEffect(anim.breathingScale)
            .offset(y: anim.breathingOffset)

            // Sleeping Zzz Particles
            if state.mood == .sleeping {
                SleepingZParticles(diameter: diameter)
                    .offset(x: diameter * 0.4, y: -diameter * 0.35 + anim.sleepZOffset)
            }

            // Happy Sparkles
            if state.mood == .happy {
                HappySparklesView(diameter: diameter)
            }

            // Native High-Precision Drag & Click Overlay
            DraggableAvatarOverlay()
                .frame(width: diameter * 1.3, height: diameter * 1.3)
        }
        .frame(width: diameter * 1.5, height: diameter * 1.5)
        .contentShape(Circle())
        .onHover { hovering in
            state.isHovered = hovering
            if hovering {
                state.wakeUp()
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    anim.squishScaleX = 1.05
                    anim.squishScaleY = 0.95
                }
            } else {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    anim.squishScaleX = 1.0
                    anim.squishScaleY = 1.0
                }
            }
        }
        .onAppear {
            anim.startAmbientAnimations()
        }
        .onChange(of: state.mood) { newMood in
            handleMoodAnimation(newMood)
        }
    }

    // MARK: - Crisp Vector Aura Glow
    private func baseAuraGlow() -> some View {
        Circle()
            .fill(
                RadialGradient(
                    gradient: Gradient(colors: [
                        config.colorTheme.glowColor,
                        config.colorTheme.glowColor.opacity(0.35),
                        config.colorTheme.glowColor.opacity(0.0)
                    ]),
                    center: .center,
                    startRadius: diameter * 0.15,
                    endRadius: diameter * 0.68
                )
            )
            .frame(width: diameter * 1.45, height: diameter * 1.45)
            .scaleEffect(state.mood == .thinking ? 1.25 : (state.mood == .speaking ? anim.speakingPulse : 1.0))
            .opacity(state.mood == .sleeping ? 0.25 : 0.9)
    }

    // MARK: - Body Shape Rendering
    @ViewBuilder
    private func mascotBodyShapeView() -> some View {
        let gradient = RadialGradient(
            gradient: Gradient(colors: [
                config.colorTheme.primaryColor,
                config.colorTheme.secondaryColor,
                config.colorTheme.secondaryColor.opacity(0.95)
            ]),
            center: .init(x: 0.35, y: 0.28),
            startRadius: diameter * 0.05,
            endRadius: diameter * 0.62
        )

        switch config.bodyShape {
        case .orb:
            Circle()
                .fill(gradient)
                .frame(width: bodyWidth, height: bodyHeight)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

        case .bean:
            Capsule()
                .fill(gradient)
                .frame(width: bodyWidth, height: bodyHeight)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)

        case .drop:
            PearShape()
                .fill(gradient)
                .frame(width: bodyWidth, height: bodyHeight)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
    }

    // MARK: - Blush Cheeks
    private func blushCheeksView() -> some View {
        HStack(spacing: bodyWidth * 0.44) {
            Circle()
                .fill(Color(red: 1.0, green: 0.35, blue: 0.55).opacity(0.45))
                .frame(width: bodyWidth * 0.17, height: bodyHeight * 0.10)
            Circle()
                .fill(Color(red: 1.0, green: 0.35, blue: 0.55).opacity(0.45))
                .frame(width: bodyWidth * 0.17, height: bodyHeight * 0.10)
        }
        .offset(y: bodyHeight * 0.04)
    }

    private func handleMoodAnimation(_ mood: DotMood) {
        switch mood {
        case .happy:
            withAnimation(.spring(response: 0.3, dampingFraction: 0.5)) {
                anim.breathingOffset = -8
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    self.anim.breathingOffset = 0
                }
            }
        case .thinking:
            SpeechService.shared.playWakeupSound()
        default:
            break
        }
    }
}

// MARK: - PearShape for Artist Drop (Felipe/Iggy)
public struct PearShape: Shape {
    public init() {}
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        let topRadius = rect.width * 0.38
        let bottomRadius = rect.width * 0.50

        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.minY + topRadius),
            radius: topRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addArc(
            center: CGPoint(x: rect.midX, y: rect.maxY - bottomRadius),
            radius: bottomRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.closeSubpath()
        return path
    }
}

// MARK: - Thinking Orbital Ring
public struct ThinkingOrbitalRing: View {
    let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    AngularGradient(
                        colors: [Color.cyan.opacity(0.1), Color.blue, Color.purple, Color.cyan],
                        center: .center
                    ),
                    lineWidth: 3
                )
                .frame(width: diameter * 1.30, height: diameter * 1.30)

            Circle()
                .fill(Color.white)
                .frame(width: 6, height: 6)
                .shadow(color: Color.cyan, radius: 4)
                .offset(y: -diameter * 0.65)
        }
    }
}

// MARK: - Sleeping Z Particles
public struct SleepingZParticles: View {
    let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    public var body: some View {
        VStack(spacing: 2) {
            Text("z")
                .font(.system(size: 11, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.8))
                .offset(x: 4)
            Text("Z")
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
                .offset(x: 10)
        }
    }
}

// MARK: - Happy Sparkles
public struct HappySparklesView: View {
    let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    public var body: some View {
        ZStack {
            Image(systemName: "sparkle")
                .font(.system(size: 14))
                .foregroundColor(.yellow)
                .offset(x: -diameter * 0.55, y: -diameter * 0.4)

            Image(systemName: "sparkle")
                .font(.system(size: 16))
                .foregroundColor(.pink)
                .offset(x: diameter * 0.55, y: -diameter * 0.35)

            Image(systemName: "star.fill")
                .font(.system(size: 11))
                .foregroundColor(.yellow)
                .offset(x: diameter * 0.45, y: diameter * 0.4)
        }
    }
}
