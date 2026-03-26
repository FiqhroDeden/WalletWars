//
//  RivalAvatar.swift
//  WalletWars
//

import SwiftUI

/// Red rival avatar — cracked shield with fang motif, jagged edges, menacing.
struct RivalAvatar: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            outerGlow
            crackedShield
            skullDetail
            glitchOverlay
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Layers

private extension RivalAvatar {
    var outerGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.rival.opacity(0.3), Color.rival.opacity(0.05), .clear],
                    center: .center,
                    startRadius: size * 0.15,
                    endRadius: size * 0.5
                )
            )
    }

    var crackedShield: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w * 0.5

            // Shield — same base shape but with jagged crack
            var shield = Path()
            shield.move(to: CGPoint(x: cx, y: h * 0.12))
            shield.addLine(to: CGPoint(x: w * 0.85, y: h * 0.28))
            shield.addLine(to: CGPoint(x: w * 0.85, y: h * 0.55))
            shield.addCurve(
                to: CGPoint(x: cx, y: h * 0.88),
                control1: CGPoint(x: w * 0.85, y: h * 0.72),
                control2: CGPoint(x: w * 0.65, y: h * 0.84)
            )
            shield.addCurve(
                to: CGPoint(x: w * 0.15, y: h * 0.55),
                control1: CGPoint(x: w * 0.35, y: h * 0.84),
                control2: CGPoint(x: w * 0.15, y: h * 0.72)
            )
            shield.addLine(to: CGPoint(x: w * 0.15, y: h * 0.28))
            shield.closeSubpath()

            // Fill with red gradient
            let gradient = Gradient(colors: [Color(hex: "FF6B52"), Color(hex: "E5432A"), Color(hex: "721C0F")])
            context.fill(shield, with: .linearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: w, y: h)))

            // Jagged crack line down the center
            var crack = Path()
            crack.move(to: CGPoint(x: cx - w * 0.02, y: h * 0.16))
            crack.addLine(to: CGPoint(x: cx + w * 0.06, y: h * 0.30))
            crack.addLine(to: CGPoint(x: cx - w * 0.04, y: h * 0.42))
            crack.addLine(to: CGPoint(x: cx + w * 0.05, y: h * 0.55))
            crack.addLine(to: CGPoint(x: cx - w * 0.02, y: h * 0.68))
            crack.addLine(to: CGPoint(x: cx + w * 0.03, y: h * 0.82))
            context.stroke(crack, with: .color(.black.opacity(0.6)), lineWidth: w * 0.025)
            context.stroke(crack, with: .color(Color(hex: "FFB8AA").opacity(0.4)), lineWidth: w * 0.01)

            // Border
            context.stroke(shield, with: .color(Color(hex: "FFB8AA").opacity(0.4)), lineWidth: w * 0.02)
        }
        .frame(width: size * 0.7, height: size * 0.7)
    }

    var skullDetail: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w * 0.5

            // Two eye holes
            var leftEye = Path()
            leftEye.move(to: CGPoint(x: cx - w * 0.14, y: h * 0.38))
            leftEye.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.33))
            leftEye.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.43))
            leftEye.closeSubpath()
            context.fill(leftEye, with: .color(.black.opacity(0.7)))

            var rightEye = Path()
            rightEye.move(to: CGPoint(x: cx + w * 0.14, y: h * 0.38))
            rightEye.addLine(to: CGPoint(x: cx + w * 0.06, y: h * 0.33))
            rightEye.addLine(to: CGPoint(x: cx + w * 0.06, y: h * 0.43))
            rightEye.closeSubpath()
            context.fill(rightEye, with: .color(.black.opacity(0.7)))

            // Jagged mouth / fang line
            var mouth = Path()
            mouth.move(to: CGPoint(x: cx - w * 0.12, y: h * 0.58))
            mouth.addLine(to: CGPoint(x: cx - w * 0.06, y: h * 0.54))
            mouth.addLine(to: CGPoint(x: cx - w * 0.02, y: h * 0.60))
            mouth.addLine(to: CGPoint(x: cx + w * 0.02, y: h * 0.54))
            mouth.addLine(to: CGPoint(x: cx + w * 0.06, y: h * 0.60))
            mouth.addLine(to: CGPoint(x: cx + w * 0.12, y: h * 0.54))
            context.stroke(mouth, with: .color(.black.opacity(0.6)), lineWidth: w * 0.02)
        }
        .frame(width: size * 0.7, height: size * 0.7)
    }

    var glitchOverlay: some View {
        // Subtle horizontal glitch lines
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height

            for i in stride(from: 0.3, through: 0.7, by: 0.08) {
                var line = Path()
                let offset = CGFloat.random(in: -w * 0.03...w * 0.03)
                line.move(to: CGPoint(x: w * 0.2 + offset, y: h * CGFloat(i)))
                line.addLine(to: CGPoint(x: w * 0.8 + offset, y: h * CGFloat(i)))
                context.stroke(line, with: .color(Color(hex: "FF6B52").opacity(0.15)), lineWidth: 1)
            }
        }
        .frame(width: size * 0.7, height: size * 0.7)
    }
}
