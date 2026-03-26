//
//  CaptureKeypad.swift
//  WalletWars
//

import SwiftUI

struct CaptureKeypad: View {
    @Binding var text: String

    private let keys: [[KeypadKey]] = [
        [.digit("1"), .digit("2"), .digit("3")],
        [.digit("4"), .digit("5"), .digit("6")],
        [.digit("7"), .digit("8"), .digit("9")],
        [.dot, .digit("0"), .delete],
    ]

    var body: some View {
        VStack(spacing: 8) {
            ForEach(keys, id: \.self) { row in
                HStack(spacing: 8) {
                    ForEach(row, id: \.self) { key in
                        KeypadButton(key: key) {
                            handleTap(key)
                        }
                    }
                }
            }
        }
    }

    private func handleTap(_ key: KeypadKey) {
        switch key {
        case .digit(let d):
            guard text.count < 10 else { return }
            // Prevent multiple leading zeros
            if text == "0" && d != "." { text = d; return }
            // Limit decimal places to 2
            if let dotIndex = text.firstIndex(of: ".") {
                let decimals = text[text.index(after: dotIndex)...]
                guard decimals.count < 2 else { return }
            }
            text += d

        case .dot:
            guard !text.contains(".") else { return }
            text += text.isEmpty ? "0." : "."

        case .delete:
            guard !text.isEmpty else { return }
            text.removeLast()
        }
    }
}

// MARK: - Keypad Key

private enum KeypadKey: Hashable {
    case digit(String)
    case dot
    case delete

    var label: String {
        switch self {
        case .digit(let d): d
        case .dot: "."
        case .delete: ""
        }
    }
}

// MARK: - Keypad Button

private struct KeypadButton: View {
    let key: KeypadKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Group {
                if case .delete = key {
                    Image(systemName: "delete.backward.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(Color.textMid)
                } else {
                    Text(key.label)
                        .font(.custom("PlusJakartaSans-SemiBold", size: 24))
                        .foregroundStyle(Color.textPrimary)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(Color.surfaceLow, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: key.label)
    }
}
