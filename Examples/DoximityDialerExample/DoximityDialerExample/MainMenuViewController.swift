import UIKit
import SwiftUI
import DoximityDialerSDK

/// Main menu for choosing between SwiftUI, UIKit (Swift), and Objective-C examples.
class MainMenuViewController: UIViewController {

    // MARK: - UI Components

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Doximity Dialer SDK"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Example App"
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let swiftUIExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SwiftUI Example", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let swiftExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UIKit (Swift) Example", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let objcExampleButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("UIKit (Objective-C) Example", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "This app demonstrates the DoximityDialerSDK integration in SwiftUI, UIKit (Swift), and UIKit (Objective-C).\n\nChoose an example to see how to integrate the SDK into your app."
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadDoximityIcon()
        updateInstallationStatus()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInstallationStatus()
    }

    // MARK: - Setup

    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Doximity Dialer SDK"

        view.addSubview(doximityIconImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(statusLabel)
        view.addSubview(swiftUIExampleButton)
        view.addSubview(swiftExampleButton)
        view.addSubview(objcExampleButton)
        view.addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            // Icon
            doximityIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            doximityIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doximityIconImageView.widthAnchor.constraint(equalToConstant: 100),
            doximityIconImageView.heightAnchor.constraint(equalToConstant: 100),

            // Title
            titleLabel.topAnchor.constraint(equalTo: doximityIconImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Status
            statusLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            statusLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            statusLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // SwiftUI Example Button
            swiftUIExampleButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 40),
            swiftUIExampleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            swiftUIExampleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            swiftUIExampleButton.heightAnchor.constraint(equalToConstant: 56),

            // UIKit Swift Example Button
            swiftExampleButton.topAnchor.constraint(equalTo: swiftUIExampleButton.bottomAnchor, constant: 12),
            swiftExampleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            swiftExampleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            swiftExampleButton.heightAnchor.constraint(equalToConstant: 56),

            // Objective-C Example Button
            objcExampleButton.topAnchor.constraint(equalTo: swiftExampleButton.bottomAnchor, constant: 12),
            objcExampleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            objcExampleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            objcExampleButton.heightAnchor.constraint(equalToConstant: 56),

            // Description
            descriptionLabel.topAnchor.constraint(equalTo: objcExampleButton.bottomAnchor, constant: 32),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }

    private func setupActions() {
        swiftUIExampleButton.addTarget(self, action: #selector(didTapSwiftUIExample), for: .touchUpInside)
        swiftExampleButton.addTarget(self, action: #selector(didTapSwiftExample), for: .touchUpInside)
        objcExampleButton.addTarget(self, action: #selector(didTapObjCExample), for: .touchUpInside)
    }

    private func loadDoximityIcon() {
        do {
            let icon = try DoximityDialer.shared.doximityIcon()
            doximityIconImageView.image = icon
        } catch {
            print("Failed to load Doximity icon: \(error)")
            doximityIconImageView.isHidden = true
        }
    }

    private func updateInstallationStatus() {
        let isInstalled = DoximityDialer.shared.isDoximityInstalled

        if isInstalled {
            statusLabel.text = "✓ Doximity is installed"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "Doximity is not installed"
            statusLabel.textColor = .systemOrange
        }
    }

    // MARK: - Actions

    @objc private func didTapSwiftUIExample() {
        let swiftUIView = SwiftUIExampleView()
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController?.pushViewController(hostingController, animated: true)
    }

    @objc private func didTapSwiftExample() {
        let swiftVC = SwiftExampleViewController()
        navigationController?.pushViewController(swiftVC, animated: true)
    }

    @objc private func didTapObjCExample() {
        let objcVC = ObjCExampleViewController()
        navigationController?.pushViewController(objcVC, animated: true)
    }
}
