#!/usr/bin/env swift

// Run: swift scripts/generate-app-icon.swift
// Outputs PNG files to WalletWars/Assets.xcassets/AppIcon.appiconset/

import SwiftUI
import AppKit

// MARK: - Color Extension

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Shield Shape (from prototype SVG path)

struct ShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        // Original SVG: M40 4 L72 20 V50 C72 64 56 74 40 78 C24 74 8 64 8 50 V20 Z
        // Normalized to 0-1 range (viewBox 80x80)
        var path = Path()
        path.move(to: CGPoint(x: w * 0.500, y: h * 0.050))    // 40/80, 4/80
        path.addLine(to: CGPoint(x: w * 0.900, y: h * 0.250)) // 72/80, 20/80
        path.addLine(to: CGPoint(x: w * 0.900, y: h * 0.625)) // 72/80, 50/80
        path.addCurve(
            to: CGPoint(x: w * 0.500, y: h * 0.975),           // 40/80, 78/80
            control1: CGPoint(x: w * 0.900, y: h * 0.800),     // 72/80, 64/80
            control2: CGPoint(x: w * 0.700, y: h * 0.925)      // 56/80, 74/80
        )
        path.addCurve(
            to: CGPoint(x: w * 0.100, y: h * 0.625),           // 8/80, 50/80
            control1: CGPoint(x: w * 0.300, y: h * 0.925),     // 24/80, 74/80
            control2: CGPoint(x: w * 0.100, y: h * 0.800)      // 8/80, 64/80
        )
        path.addLine(to: CGPoint(x: w * 0.100, y: h * 0.250)) // 8/80, 20/80
        path.closeSubpath()
        return path
    }
}

struct InnerShieldShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        // M40 12 L64 24 V48 C64 58 52 66 40 70 C28 66 16 58 16 48 V24 Z
        var path = Path()
        path.move(to: CGPoint(x: w * 0.500, y: h * 0.150))
        path.addLine(to: CGPoint(x: w * 0.800, y: h * 0.300))
        path.addLine(to: CGPoint(x: w * 0.800, y: h * 0.600))
        path.addCurve(
            to: CGPoint(x: w * 0.500, y: h * 0.875),
            control1: CGPoint(x: w * 0.800, y: h * 0.725),
            control2: CGPoint(x: w * 0.650, y: h * 0.825)
        )
        path.addCurve(
            to: CGPoint(x: w * 0.200, y: h * 0.600),
            control1: CGPoint(x: w * 0.350, y: h * 0.825),
            control2: CGPoint(x: w * 0.200, y: h * 0.725)
        )
        path.addLine(to: CGPoint(x: w * 0.200, y: h * 0.300))
        path.closeSubpath()
        return path
    }
}

// MARK: - Icon View (Light)

struct IconView: View {
    let size: CGFloat
    let darkMode: Bool

    private let heroBlue = Color(hex: "1B6EF2")
    private let heroLight = Color(hex: "8AACFF")
    private let navy = Color(hex: "090E1C")
    private let navyLight = Color(hex: "0D1530")
    private let amber = Color(hex: "F5A623")

    var body: some View {
        ZStack {
            background
            ambientGlow
            shieldOuter
            shieldInner
            wwText
            bottomAccent
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
    }

    private var background: some View {
        LinearGradient(
            colors: darkMode ? [navy, navyLight] : [Color(hex: "0A1840"), Color(hex: "0F2060")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var ambientGlow: some View {
        RadialGradient(
            colors: [heroBlue.opacity(0.2), heroBlue.opacity(0)],
            center: .init(x: 0.5, y: 0.45),
            startRadius: 0,
            endRadius: size * 0.5
        )
    }

    private var shieldOuter: some View {
        ShieldShape()
            .fill(
                LinearGradient(
                    colors: [heroLight, heroBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.25)
            )
            .overlay(
                ShieldShape()
                    .stroke(
                        LinearGradient(
                            colors: [heroLight, heroBlue],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: size * 0.025
                    )
            )
            .frame(width: size * 0.82, height: size * 0.82)
    }

    private var shieldInner: some View {
        InnerShieldShape()
            .fill(
                LinearGradient(
                    colors: [heroLight, heroBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(0.1)
            )
            .frame(width: size * 0.82, height: size * 0.82)
    }

    private var wwText: some View {
        Text("WW")
            .font(.system(size: size * 0.22, weight: .heavy, design: .rounded))
            .foregroundStyle(
                LinearGradient(
                    colors: [heroLight, heroBlue],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: heroLight.opacity(0.5), radius: size * 0.02)
            .offset(y: size * 0.02)
    }

    private var bottomAccent: some View {
        RadialGradient(
            colors: [amber.opacity(darkMode ? 0.1 : 0.15), amber.opacity(0)],
            center: .init(x: 0.5, y: 0.88),
            startRadius: 0,
            endRadius: size * 0.12
        )
    }
}

// MARK: - Tinted Icon

struct TintedIconView: View {
    let size: CGFloat

    var body: some View {
        ZStack {
            Color(hex: "1B6EF2")

            ShieldShape()
                .fill(.white.opacity(0.15))
                .frame(width: size * 0.82, height: size * 0.82)

            ShieldShape()
                .stroke(.white.opacity(0.3), lineWidth: size * 0.02)
                .frame(width: size * 0.82, height: size * 0.82)

            Text("WW")
                .font(.system(size: size * 0.22, weight: .heavy, design: .rounded))
                .foregroundStyle(.white.opacity(0.9))
                .offset(y: size * 0.02)
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: size * 0.22, style: .continuous))
    }
}

// MARK: - Render to PNG

@MainActor
func renderToPNG<V: View>(_ view: V, size: CGFloat, filename: String) {
    let renderer = ImageRenderer(content: view)
    renderer.scale = 1.0
    renderer.proposedSize = .init(width: size, height: size)

    guard let nsImage = renderer.nsImage else {
        print("  Failed to render \(filename)")
        return
    }

    guard let tiffData = nsImage.tiffRepresentation,
          let bitmap = NSBitmapImageRep(data: tiffData),
          let pngData = bitmap.representation(using: .png, properties: [:]) else {
        print("  Failed to convert \(filename) to PNG")
        return
    }

    let scriptDir = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
    let projectDir = scriptDir.deletingLastPathComponent()
    let outputDir = projectDir
        .appendingPathComponent("WalletWars/Assets.xcassets/AppIcon.appiconset")

    let outputPath = outputDir.appendingPathComponent(filename)

    do {
        try pngData.write(to: outputPath)
        print("  Saved: \(outputPath.lastPathComponent) (\(Int(size))x\(Int(size)))")
    } catch {
        print("  Error writing \(filename): \(error)")
    }
}

// MARK: - Main

@MainActor
func main() {
    let size: CGFloat = 1024

    print("Generating WalletWars app icons (1024x1024)...")
    print("")

    renderToPNG(IconView(size: size, darkMode: false), size: size, filename: "AppIcon-Light.png")
    renderToPNG(IconView(size: size, darkMode: true), size: size, filename: "AppIcon-Dark.png")
    renderToPNG(TintedIconView(size: size), size: size, filename: "AppIcon-Tinted.png")

    print("")
    print("Done! Icons saved to WalletWars/Assets.xcassets/AppIcon.appiconset/")
    print("Contents.json has been updated to reference these files.")
}

MainActor.assumeIsolated {
    main()
}
