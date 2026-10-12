import Foundation
import SwiftUI

public struct AccessoriesView: View {
    @ObservedObject var config: DotConfig = DotConfig.shared
    let diameter: CGFloat

    public init(diameter: CGFloat) {
        self.diameter = diameter
    }

    public var body: some View {
        ZStack {
            switch config.accessory {
            case .none:
                EmptyView()

            case .roundGlasses:
                roundGlassesView()

            case .coolSunglasses:
                coolSunglassesView()

            case .nerdGlasses:
                nerdGlassesView()

            case .bowtie:
                bowtieView()

            case .beret:
                beretView()

            case .sprout:
                sproutView()

            case .crown:
                crownView()

            case .beanie:
                beanieView()

            case .partyHat:
                partyHatView()

            case .headphones:
                headphonesView()
            }
        }
    }

    // MARK: - Glasses
    private func roundGlassesView() -> some View {
        let lensSize = diameter * 0.28
        let spacing = diameter * 0.20
        return HStack(spacing: spacing) {
            Circle()
                .stroke(Color.white.opacity(0.95), lineWidth: 2.5)
                .background(Circle().fill(Color.white.opacity(0.12)))
                .frame(width: lensSize, height: lensSize)

            Circle()
                .stroke(Color.white.opacity(0.95), lineWidth: 2.5)
                .background(Circle().fill(Color.white.opacity(0.12)))
                .frame(width: lensSize, height: lensSize)
        }
        .overlay(
            Rectangle()
                .fill(Color.white.opacity(0.95))
                .frame(width: spacing + 4, height: 2.2)
        )
    }

    private func coolSunglassesView() -> some View {
        let lensWidth = diameter * 0.32
        let lensHeight = diameter * 0.22
        return HStack(spacing: 4) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.12))
                    .frame(width: lensWidth, height: lensHeight)
                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 3, height: lensHeight * 0.7)
                    .rotationEffect(.degrees(25))
            }
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.1, green: 0.1, blue: 0.12))
                    .frame(width: lensWidth, height: lensHeight)
                Rectangle()
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 3, height: lensHeight * 0.7)
                    .rotationEffect(.degrees(25))
            }
        }
        .overlay(
            Rectangle()
                .fill(Color.black)
                .frame(width: diameter * 0.75, height: 3)
                .offset(y: -lensHeight * 0.45)
        )
    }

    private func nerdGlassesView() -> some View {
        let frameWidth = diameter * 0.30
        let frameHeight = diameter * 0.24
        return HStack(spacing: diameter * 0.18) {
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(red: 0.12, green: 0.12, blue: 0.16), lineWidth: 3.5)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.1)))
                .frame(width: frameWidth, height: frameHeight)

            RoundedRectangle(cornerRadius: 5)
                .stroke(Color(red: 0.12, green: 0.12, blue: 0.16), lineWidth: 3.5)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.white.opacity(0.1)))
                .frame(width: frameWidth, height: frameHeight)
        }
        .overlay(
            Rectangle()
                .fill(Color(red: 0.12, green: 0.12, blue: 0.16))
                .frame(width: diameter * 0.24, height: 3.5)
        )
    }

    // MARK: - Sprout (Todd's signature)
    private func sproutView() -> some View {
        VStack(spacing: 0) {
            ZStack {
                // Stem
                Capsule()
                    .fill(Color(red: 0.38, green: 0.78, blue: 0.22))
                    .frame(width: diameter * 0.06, height: diameter * 0.22)
                    .offset(y: 4)

                // Left Leaf
                Ellipse()
                    .fill(Color(red: 0.42, green: 0.85, blue: 0.25))
                    .frame(width: diameter * 0.22, height: diameter * 0.12)
                    .rotationEffect(.degrees(-32))
                    .offset(x: -diameter * 0.10, y: -diameter * 0.08)

                // Right Leaf
                Ellipse()
                    .fill(Color(red: 0.48, green: 0.90, blue: 0.28))
                    .frame(width: diameter * 0.24, height: diameter * 0.13)
                    .rotationEffect(.degrees(28))
                    .offset(x: diameter * 0.11, y: -diameter * 0.09)
            }
            Spacer()
        }
        .offset(y: -diameter * 0.46)
    }

    // MARK: - Beret (Felipe's signature)
    private func beretView() -> some View {
        VStack(spacing: 0) {
            ZStack {
                // Beret base
                Ellipse()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.15, green: 0.22, blue: 0.45), Color(red: 0.10, green: 0.15, blue: 0.32)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: diameter * 0.78, height: diameter * 0.34)
                    .shadow(color: Color.black.opacity(0.25), radius: 3, x: 0, y: 2)

                // Little tip stalk
                Capsule()
                    .fill(Color(red: 0.10, green: 0.15, blue: 0.32))
                    .frame(width: 4, height: 10)
                    .offset(y: -diameter * 0.16)
            }
            Spacer()
        }
        .rotationEffect(.degrees(-10))
        .offset(x: -diameter * 0.06, y: -diameter * 0.44)
    }

    // MARK: - Bow Tie (Alfred's signature)
    private func bowtieView() -> some View {
        VStack {
            Spacer()
            HStack(spacing: -3) {
                // Left Wing
                BowTieWingShape()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.22, green: 0.48, blue: 0.92), Color(red: 0.15, green: 0.35, blue: 0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: diameter * 0.18, height: diameter * 0.16)
                    .rotationEffect(.degrees(180))

                // Center Knot
                Circle()
                    .fill(Color(red: 0.18, green: 0.38, blue: 0.85))
                    .frame(width: diameter * 0.09, height: diameter * 0.09)
                    .shadow(color: Color.black.opacity(0.2), radius: 1)

                // Right Wing
                BowTieWingShape()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.22, green: 0.48, blue: 0.92), Color(red: 0.15, green: 0.35, blue: 0.75)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: diameter * 0.18, height: diameter * 0.16)
            }
            .offset(y: diameter * 0.28)
        }
    }

    // MARK: - Hats
    private func crownView() -> some View {
        VStack(spacing: 0) {
            ZStack {
                CrownShape()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.85, blue: 0.2), Color(red: 0.95, green: 0.65, blue: 0.1)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: diameter * 0.45, height: diameter * 0.28)
                    .shadow(color: Color.yellow.opacity(0.5), radius: 3)

                Circle()
                    .fill(Color(red: 0.95, green: 0.2, blue: 0.3))
                    .frame(width: diameter * 0.08, height: diameter * 0.08)
                    .offset(y: diameter * 0.04)
            }
            Spacer()
        }
        .offset(y: -diameter * 0.44)
    }

    private func beanieView() -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color.white)
                .frame(width: diameter * 0.14, height: diameter * 0.14)
                .offset(y: 4)

            BeanieDomeShape()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.95, green: 0.3, blue: 0.35), Color(red: 0.75, green: 0.18, blue: 0.25)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: diameter * 0.72, height: diameter * 0.36)
                .overlay(
                    Capsule()
                        .fill(Color.white)
                        .frame(width: diameter * 0.75, height: diameter * 0.12)
                        .offset(y: diameter * 0.14)
                )
            Spacer()
        }
        .offset(y: -diameter * 0.46)
    }

    private func partyHatView() -> some View {
        VStack(spacing: 0) {
            Circle()
                .fill(Color.yellow)
                .frame(width: diameter * 0.10, height: diameter * 0.10)
                .offset(y: 3)

            PartyConeShape()
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.2, green: 0.85, blue: 0.9), Color(red: 0.9, green: 0.3, blue: 0.8)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: diameter * 0.32, height: diameter * 0.42)
            Spacer()
        }
        .rotationEffect(.degrees(12))
        .offset(x: diameter * 0.15, y: -diameter * 0.48)
    }

    // MARK: - Headphones
    private func headphonesView() -> some View {
        ZStack {
            HeadbandShape()
                .stroke(Color(red: 0.18, green: 0.18, blue: 0.22), lineWidth: 4.5)
                .frame(width: diameter * 0.95, height: diameter * 0.70)
                .offset(y: -diameter * 0.20)

            HStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(config.colorTheme.primaryColor, lineWidth: 2)
                    )
                    .frame(width: diameter * 0.16, height: diameter * 0.34)

                Spacer()

                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(red: 0.12, green: 0.12, blue: 0.16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(config.colorTheme.primaryColor, lineWidth: 2)
                    )
                    .frame(width: diameter * 0.16, height: diameter * 0.34)
            }
            .frame(width: diameter * 1.05)
        }
    }
}

// Shapes
struct BowTieWingShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct CrownShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.maxY * 0.75))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.width * 0.75, y: rect.maxY * 0.75))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct BeanieDomeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        path.closeSubpath()
        return path
    }
}

struct PartyConeShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 1.1)
        )
        path.closeSubpath()
        return path
    }
}

struct HeadbandShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.minY)
        )
        return path
    }
}
