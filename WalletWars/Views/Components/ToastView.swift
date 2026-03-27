//
//  ToastView.swift
//  WalletWars
//

import SwiftUI

struct ToastView: View {
    let icon: String
    let message: String
    @Binding var isShowing: Bool

    var body: some View {
        if isShowing {
            VStack {
                Spacer()
                toastContent
                    .padding(.bottom, 40)
            }
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.springMedium) {
                        isShowing = false
                    }
                }
            }
        }
    }

    private var toastContent: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.victory)

            Text(message)
                .font(.custom("PlusJakartaSans-SemiBold", size: 14))
                .foregroundStyle(Color.textPrimary)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(.ultraThinMaterial, in: Capsule())
    }
}
