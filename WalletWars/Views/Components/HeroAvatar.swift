//
//  HeroAvatar.swift
//  WalletWars
//

import SwiftUI

/// Blue warrior avatar — upward shield with embedded sword, layered glow.
struct HeroAvatar: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            outerGlow
            shieldBody
            swordDetail
            topHighlight
        }
        .frame(width: size, height: size)
    }
}

// MARK: - Layers

private extension HeroAvatar {
    var outerGlow: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.hero.opacity(0.3), Color.hero.opacity(0.05), .clear],
                    center: .center,
                    startRadius: size * 0.15,
                    endRadius: size * 0.5
                )
            )
    }

    var shieldBody: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w * 0.5

            // Shield path — pointed bottom, broad shoulders
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

            // Fill with gradient
            let gradient = Gradient(colors: [Color(hex: "4D8FFF"), Color(hex: "1B6EF2"), Color(hex: "0A4FBD")])
            context.fill(shield, with: .linearGradient(gradient, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: w, y: h)))

            // Inner stroke
            context.stroke(shield, with: .color(Color(hex: "A8C8FF").opacity(0.5)), lineWidth: w * 0.02)
        }
        .frame(width: size * 0.7, height: size * 0.7)
    }

    var swordDetail: some View {
        Canvas { context, canvasSize in
            let w = canvasSize.width
            let h = canvasSize.height
            let cx = w * 0.5

            // Vertical sword blade
            var blade = Path()
            blade.move(to: CGPoint(x: cx, y: h * 0.18))
            blade.addLine(to: CGPoint(x: cx + w * 0.04, y: h * 0.22))
            blade.addLine(to: CGPoint(x: cx + w * 0.03, y: h * 0.58))
            blade.addLine(to: CGPoint(x: cx, y: h * 0.65))
            blade.addLine(to: CGPoint(x: cx - w * 0.03, y: h * 0.58))
            blade.addLine(to: CGPoint(x: cx - w * 0.04, y: h * 0.22))
            blade.closeSubpath()
            context.fill(blade, with: .color(.white.opacity(0.9)))

            // Crossguard
            var guard_ = Path()
            guard_.move(to: CGPoint(x: cx - w * 0.14, y: h * 0.56))
            guard_.addLine(to: CGPoint(x: cx + w * 0.14, y: h * 0.56))
            guard_.addLine(to: CGPoint(x: cx + w * 0.12, y: h * 0.60))
            guard_.addLine(to: CGPoint(x: cx - w * 0.12, y: h * 0.60))
            guard_.closeSubpath()
            context.fill(guard_, with: .color(Color(hex: "F5A623")))

            // Pommel
            var pommel = Path()
            pommel.addEllipse(in: CGRect(x: cx - w * 0.04, y: h * 0.62, width: w * 0.08, height: h * 0.06))
            context.fill(pommel, with: .color(Color(hex: "F5A623")))
        }
        .frame(width: size * 0.7, height: size * 0.7)
    }

    var topHighlight: some View {
        Ellipse()
            .fill(
                LinearGradient(
                    colors: [.white.opacity(0.2), .clear],
                    startPoint: .top,
                    endPoint: .center
                )
            )
            .frame(width: size * 0.5, height: size * 0.25)
            .offset(y: -size * 0.12)
    }
}
