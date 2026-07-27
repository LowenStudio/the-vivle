//
//  ObboardingView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//


//
//  OnboardingView.swift
//  The Vivle
//
//  Created by Lowen on 4/28/26.
//

import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var firstName = ""

    @State private var showNameError = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                Spacer().frame(height: 40)

                Text("Welcome")
                    .font(.system(size: 28, weight: .semibold))

                Spacer().frame(height: 20)

                nameSection

                Spacer()

                Button("Continue", action: completeOnboarding)
                    .font(.system(size: 16, weight: .medium))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.primary)
                    .foregroundColor(Color(.systemBackground))
                    .cornerRadius(12)
                    .padding(.bottom, 24)
            }
            .padding(24)
        }
        .background(Color(.systemBackground))
    }

    private var nameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Name")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.gray)

            TextField("First name", text: $firstName)
                .textContentType(.givenName)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled()
                .padding(12)
                .background(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(showNameError ? Color.red : Color.gray.opacity(0.2), lineWidth: 1)
                )

            if showNameError {
                Text("Please enter your first name")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
    }

    private func completeOnboarding() {
        let trimmedFirstName = firstName.trimmingCharacters(in: .whitespacesAndNewlines)

        showNameError = trimmedFirstName.isEmpty

        guard !showNameError else {
            return
        }

        UserDefaults.standard.set(trimmedFirstName, forKey: UserDefaultsKey.userName)
        UserDefaults.standard.set(true, forKey: UserDefaultsKey.hasCompletedOnboarding)

        onComplete()
    }
}

#Preview {
    OnboardingView {}
}
