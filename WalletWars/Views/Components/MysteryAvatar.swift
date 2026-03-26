//
//  MysteryAvatar.swift
//  WalletWars
//

import SwiftUI

/// Grey mystery avatar for "no opponent yet" state — foggy silhouette.
struct MysteryAvatar: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            // Foggy outer ring
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color.textLight.opacity(0.15), Color.textLight.opacity(0.03), .clear],
                        center: .center,
                        startRadius: size * 0.1,
                        endRadius: size * 0.5
                    )
                )

            // Faded shield silhouette
            Canvas { context, canvasSize in
                let w = canvasSize.width
                let h = canvasSize.height
                let cx = w * 0.5

                var shield = Path()
                shield.move(to: CGPoint(x: cx, y: h * 0.15))
                shield.addLine(to: CGPoint(x: w * 0.82, y: h * 0.30))
                shield.addLine(to: CGPoint(x: w * 0.82, y: h * 0.55))
                shield.addCurve(
                    to: CGPoint(x: cx, y: h * 0.85),
                    control1: CGPoint(x: w * 0.82, y: h * 0.70),
                    control2: CGPoint(x: w * 0.62, y: h * 0.82)
                )
                shield.addCurve(
                    to: CGPoint(x: w * 0.18, y: h * 0.55),
                    control1: CGPoint(x: w * 0.38, y: h * 0.82),
                    control2: CGPoint(x: w * 0.18, y: h * 0.70)
                )
                shield.addLine(to: CGPoint(x: w * 0.18, y: h * 0.30))
                shield.closeSubpath()

                context.fill(shield, with: .color(Color.textLight.opacity(0.1)))
                context.stroke(shield, with: .color(Color.textLight.opacity(0.2)), style: StrokeStyle(lineWidth: w * 0.02, dash: [w * 0.04, w * 0.03]))
            }
            .frame(width: size * 0.65, height: size * 0.65)

            // Question mark
            Text("?")
                .font(.system(size: size * 0.25, weight: .heavy, design: .rounded))
                .foregroundStyle(Color.textLight.opacity(0.4))
        }
        .frame(width: size, height: size)
    }
}
