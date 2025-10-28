import SwiftUI
import DoximityDialerSDK

struct SwiftUIExampleView: View {
    @State private var phoneNumber = ""
    @State private var doximityIcon: UIImage?
    @State private var showError = false
    @State private var errorMessage = ""

    private let isDoximityInstalled = DoximityDialer.shared.isDoximityInstalled

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    if let icon = doximityIcon {
                        Image(uiImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }

                    Text(isDoximityInstalled ? "✓ Doximity is installed" : "Doximity is not installed")
                        .font(.body)
                        .foregroundColor(isDoximityInstalled ? .green : .orange)
                }
                .padding(.top, 40)

                // Phone Number Input
                TextField("Enter phone number", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.phonePad)
                    .autocorrectionDisabled()
                    .padding(.horizontal, 32)

                // Action Buttons
                VStack(spacing: 16) {
                    Button {
                        dialNumber()
                    } label: {
                        Text("Call with Doximity (Prefill)")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }

                    Button {
                        startVoiceCall()
                    } label: {
                        Text("Start Voice Call")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green)
                            .cornerRadius(12)
                    }

                    Button {
                        startVideoCall()
                    } label: {
                        Text("Start Video Call")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 32)

                Spacer(minLength: 40)

                // Description
                VStack(spacing: 16) {
                    Text("This example demonstrates the DoximityDialerSDK in SwiftUI.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Prefill: Opens Doximity with the number, letting the user choose call type.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("Voice/Video: Automatically starts the selected call type.")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    .multilineTextAlignment(.center)

                    VStack(spacing: 4) {
                        Text("Phone numbers can be formatted any way:")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("• 5551234567")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("• (555) 123-4567")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)

                        Text("• +1 (555) 123-4567")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("SwiftUI Example")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            loadIcon()
        }
    }

    // MARK: - Actions

    private func dialNumber() {
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    private func startVoiceCall() {
        DoximityDialer.shared.startVoiceCall(phoneNumber)
    }

    private func startVideoCall() {
        DoximityDialer.shared.startVideoCall(phoneNumber)
    }

    private func loadIcon() {
        do {
            doximityIcon = try DoximityDialer.shared.doximityIcon()
        } catch {
            errorMessage = "Failed to load icon: \(error.localizedDescription)"
            showError = true
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        SwiftUIExampleView()
    }
}
