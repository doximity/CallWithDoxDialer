import SwiftUI
import Combine
import DoximityDialerSDK

struct SwiftUIExampleView: View {
    @State private var phoneNumber = ""
    @State private var doximityIcon: UIImage?
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isDoximityInstalled = DoximityDialer.shared.isDoximityInstalled

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 20) {
                    if let icon = doximityIcon {
                        Image(uiImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                    }

                    Text(isDoximityInstalled ? "✓ Doximity is installed" : "Doximity is not installed\nInstall it to make calls")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(isDoximityInstalled ? .green : .red)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                .padding(.bottom, 40)

                // Phone Number Input
                VStack(spacing: 0) {
                    TextField("Enter phone number", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.phonePad)
                        .autocorrectionDisabled()
                        .frame(height: 50)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)

                // Action Buttons
                VStack(spacing: 12) {
                    Button {
                        dialNumber()
                    } label: {
                        Text("Call with Doximity (Prefill)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .disabled(!isDoximityInstalled)
                    .opacity(isDoximityInstalled ? 1.0 : 0.5)

                    Button {
                        startVoiceCall()
                    } label: {
                        Text("Start Voice Call")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .disabled(!isDoximityInstalled)
                    .opacity(isDoximityInstalled ? 1.0 : 0.5)

                    Button {
                        startVideoCall()
                    } label: {
                        Text("Start Video Call")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                    .disabled(!isDoximityInstalled)
                    .opacity(isDoximityInstalled ? 1.0 : 0.5)

                    if !isDoximityInstalled {
                        Button {
                            installDoximity()
                        } label: {
                            Text("Install Doximity")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.orange)
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)

                // Description
                VStack(spacing: 0) {
                    Text("This example demonstrates the DoximityDialerSDK in SwiftUI.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    Text("Prefill: Opens Doximity with the number, letting the user choose call type.\nVoice/Video: Automatically starts the selected call type.")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 8)

                    VStack(spacing: 0) {
                        Text("Phone numbers can be formatted any way:")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        Text("• 5551234567")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        Text("• (555) 123-4567")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)

                        Text("• +1 (555) 123-4567")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
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
            updateInstallationStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            updateInstallationStatus()
        }
    }

    // MARK: - Actions

    private func dialNumber() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            showError = true
            return
        }
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    private func startVoiceCall() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            showError = true
            return
        }
        DoximityDialer.shared.startVoiceCall(phoneNumber)
    }

    private func startVideoCall() {
        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter a phone number"
            showError = true
            return
        }
        DoximityDialer.shared.startVideoCall(phoneNumber)
    }

    private func installDoximity() {
        // When Doximity is not installed, any dial method redirects to the App Store
        // We can use any method to trigger the installation flow
        DoximityDialer.shared.dialPhoneNumber("")
    }

    private func loadIcon() {
        do {
            doximityIcon = try DoximityDialer.shared.doximityIcon()
        } catch {
            errorMessage = "Failed to load icon: \(error.localizedDescription)"
            showError = true
        }
    }

    private func updateInstallationStatus() {
        isDoximityInstalled = DoximityDialer.shared.isDoximityInstalled
    }
}

// MARK: - Preview

#Preview {
    NavigationView {
        SwiftUIExampleView()
    }
}
