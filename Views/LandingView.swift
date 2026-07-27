

import SwiftUI

struct LandingView: View {
    let onStart: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "book.closed.fill")
                .font(.system(size: 42, weight: .regular))
                .accessibilityHidden(true)

            Text("The Vivle")
                .font(.system(size: 34, weight: .semibold))
                .tracking(-0.6)

            Text("God’s Word, every hour.\nQuietly with you.")
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4)

            Spacer()

            Button(action: onStart) {
                Text("Start")
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary.opacity(0.9))
                    .cornerRadius(12)
                    .shadow(color: Color.primary.opacity(0.1), radius: 10, y: 4)
                    .foregroundColor(Color(.systemBackground))
            }

            Text("Offline. Private. Simple.")
                .font(.system(size: 12))
                .foregroundColor(.gray.opacity(0.7))
        }
        .padding(24)
        .background(Color(.systemBackground))
    }
}

#Preview {
    LandingView {}
}
