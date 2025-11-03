import UIKit
import DoximityDialerSDK

/// Swift example demonstrating DoximityDialerSDK integration.
///
/// This example shows:
/// - Checking if Doximity is installed
/// - Displaying the Doximity icon
/// - Initiating calls with prefill, voice, and video options
/// - Proper UI/UX patterns for integration
class SwiftExampleViewController: UIViewController {

    // MARK: - UI Components

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let doximityIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let statusLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let phoneNumberTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter phone number"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .phonePad
        textField.text = ""
        textField.font = .systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private let prefillButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Call with Doximity (Prefill)", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let voiceCallButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Voice Call", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let videoCallButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Video Call", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemPurple
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let installDoximityButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Install Doximity", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let instructionsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.text = """
        This example demonstrates the DoximityDialerSDK in Swift.

        Prefill: Opens Doximity with the number, letting the user choose call type.
        Voice/Video: Automatically starts the selected call type.

        Phone numbers can be formatted any way:
        • 5551234567
        • (555) 123-4567
        • +1 (555) 123-4567
        """
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadDoximityIcon()
        updateUIForInstallationStatus()
        setupNotificationObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForInstallationStatus()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Swift Example"

        // Add hierarchy
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(doximityIconImageView)
        contentView.addSubview(statusLabel)
        contentView.addSubview(phoneNumberTextField)
        contentView.addSubview(prefillButton)
        contentView.addSubview(voiceCallButton)
        contentView.addSubview(videoCallButton)
        contentView.addSubview(installDoximityButton)
        contentView.addSubview(instructionsLabel)

        // Layout
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Icon
            doximityIconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            doximityIconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            doximityIconImageView.widthAnchor.constraint(equalToConstant: 80),
            doximityIconImageView.heightAnchor.constraint(equalToConstant: 80),

            // Status
            statusLabel.topAnchor.constraint(equalTo: doximityIconImageView.bottomAnchor, constant: 20),
            statusLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            // Phone Number
            phoneNumberTextField.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            phoneNumberTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            phoneNumberTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            phoneNumberTextField.heightAnchor.constraint(equalToConstant: 50),

            // Prefill Button
            prefillButton.topAnchor.constraint(equalTo: phoneNumberTextField.bottomAnchor, constant: 24),
            prefillButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            prefillButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            prefillButton.heightAnchor.constraint(equalToConstant: 56),

            // Voice Call Button
            voiceCallButton.topAnchor.constraint(equalTo: prefillButton.bottomAnchor, constant: 12),
            voiceCallButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            voiceCallButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            voiceCallButton.heightAnchor.constraint(equalToConstant: 56),

            // Video Call Button
            videoCallButton.topAnchor.constraint(equalTo: voiceCallButton.bottomAnchor, constant: 12),
            videoCallButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            videoCallButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            videoCallButton.heightAnchor.constraint(equalToConstant: 56),

            // Install Button
            installDoximityButton.topAnchor.constraint(equalTo: videoCallButton.bottomAnchor, constant: 12),
            installDoximityButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            installDoximityButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            installDoximityButton.heightAnchor.constraint(equalToConstant: 56),

            // Instructions
            instructionsLabel.topAnchor.constraint(equalTo: installDoximityButton.bottomAnchor, constant: 40),
            instructionsLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            instructionsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
        ])
    }

    private func setupActions() {
        prefillButton.addTarget(self, action: #selector(didTapPrefillButton), for: .touchUpInside)
        voiceCallButton.addTarget(self, action: #selector(didTapVoiceCallButton), for: .touchUpInside)
        videoCallButton.addTarget(self, action: #selector(didTapVideoCallButton), for: .touchUpInside)
        installDoximityButton.addTarget(self, action: #selector(didTapInstallButton), for: .touchUpInside)

        // Dismiss keyboard when tapping outside
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleAppDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    // MARK: - Doximity Icon

    private func loadDoximityIcon() {
        do {
            let icon = try DoximityDialer.shared.doximityIcon()
            doximityIconImageView.image = icon
        } catch {
            print("Failed to load Doximity icon: \(error)")
            doximityIconImageView.isHidden = true
        }
    }

    // MARK: - Installation Status

    private func updateUIForInstallationStatus() {
        let isInstalled = DoximityDialer.shared.isDoximityInstalled

        // Update button states
        prefillButton.isEnabled = isInstalled
        voiceCallButton.isEnabled = isInstalled
        videoCallButton.isEnabled = isInstalled
        installDoximityButton.isHidden = isInstalled

        // Update button appearance for disabled state
        let alpha: CGFloat = isInstalled ? 1.0 : 0.5
        prefillButton.alpha = alpha
        voiceCallButton.alpha = alpha
        videoCallButton.alpha = alpha

        // Update status label
        if isInstalled {
            statusLabel.text = "✓ Doximity is installed"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "Doximity is not installed\nInstall it to make calls"
            statusLabel.textColor = .systemRed
        }
    }

    @objc private func handleAppDidBecomeActive() {
        updateUIForInstallationStatus()
    }

    // MARK: - Actions

    @objc private func didTapPrefillButton() {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter a phone number")
            return
        }

        // Prefill the number in Doximity Dialer
        // This lets the user choose whether to start a voice or video call
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    @objc private func didTapVoiceCallButton() {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter a phone number")
            return
        }

        // Automatically start a voice call
        DoximityDialer.shared.startVoiceCall(phoneNumber)
    }

    @objc private func didTapVideoCallButton() {
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showAlert(title: "Error", message: "Please enter a phone number")
            return
        }

        // Automatically start a video call
        DoximityDialer.shared.startVideoCall(phoneNumber)
    }

    @objc private func didTapInstallButton() {
        // When Doximity is not installed, any dial method redirects to the App Store
        // We can use any method to trigger the installation flow
        DoximityDialer.shared.dialPhoneNumber("")
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - Helper

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
