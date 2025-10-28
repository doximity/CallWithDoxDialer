import Foundation
import UIKit

/// A struct to handle dialing phone numbers using the Doximity app.
public struct DoximityDialer {
    /// Singleton instance of `DoximityDialer`.
    public static let shared = DoximityDialer()

    /// Errors that can occur when using `DoximityDialer`.
    public enum DoximityDialerError: Error {
        /// The Doximity icon image asset could not be found in the SDK bundle or package resources.
        case imageAssetNotFound
    }

    /// Constants used in `DoximityDialer`.
    private enum Constants {
        static let doximityScheme = "doximity://"
        static let dialerTargetNumberPath = "dialer/call?target_number="
        static let appsFlyerID = "id393642611"
        static let bundleID = Bundle.main.bundleIdentifier ?? "com.doximity.dialersdk"
    }

    private let application: OpenApplicationURL

    /// Options for how Doximity Dialer should handle the phone number.
    public enum Options: Equatable {
        /// The type of call to initiate.
        public enum Kind: String, Equatable {
            /// Voice call
            case voice
            /// Video call
            case video
        }

        /// Prefills the phone number in Doximity Dialer without automatically starting the call.
        case prefill

        /// Automatically starts a call in Doximity Dialer of the specified `Kind`.
        case startCall(Kind)

        var path: String {
            let base = "/dialer/call"

            return switch self {
            case .prefill:
                base
            case let .startCall(kind):
                "\(base)/\(kind.rawValue)"
            }
        }
    }

    init(application: OpenApplicationURL = UIApplication.shared) {
        self.application = application
    }

    /// Dials a phone number using Doximity Dialer.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer with the specified phone number and options.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameters:
    ///   - phoneNumber: The phone number to dial (e.g., "5551234567")
    ///   - options: How to handle the phone number. Defaults to `.prefill` which opens the Doximity Dialer
    ///              without automatically starting the call. Use `.startCall(.voice)` or `.startCall(.video)`
    ///              to automatically initiate a voice or video call.
    public func dialPhoneNumber(_ phoneNumber: String, options: Options = .prefill) {
        guard isDoximityInstalled else {
            openURL(doximityAppStoreURL)
            return
        }

        var components = URLComponents()
        components.scheme = "doximity"
        components.path = options.path
        components.queryItems = [
            URLQueryItem(name: "target_number", value: phoneNumber),
            URLQueryItem(name: "utm_source", value: Constants.bundleID)
        ]

        openURL(components.url)
    }

    /// Returns the Doximity icon image.
    ///
    /// - Returns: The Doximity icon as a `UIImage`.
    /// - Throws: `DoximityDialerError.imageAssetNotFound` if the icon cannot be loaded from the SDK resources.
    public func doximityIcon() throws -> UIImage {
        guard let image = iconFromPackage ?? iconFromBundle else {
            throw DoximityDialerError.imageAssetNotFound
        }
        return image
    }

    /// Returns the Doximity icon image as a template for UI customization.
    ///
    /// The returned image uses `.alwaysTemplate` rendering mode, allowing you to tint it with your app's colors.
    ///
    /// - Returns: The Doximity icon as a template `UIImage`.
    /// - Throws: `DoximityDialerError.imageAssetNotFound` if the icon cannot be loaded from the SDK resources.
    public func doximityIconAsTemplate() throws -> UIImage {
        guard let image = iconFromPackage ?? iconFromBundle else {
            throw DoximityDialerError.imageAssetNotFound
        }
        return image.withRenderingMode(.alwaysTemplate)
    }
}

private extension DoximityDialer {
    /// Doximity icon asset from the swift package resources
    var iconFromPackage: UIImage? {
    #if SWIFT_PACKAGE
        guard
            let image = UIImage(
                named: "icon",
                in: .module,
                compatibleWith: nil
            )
        else {
            return UIImage()
        }
        return image
    #else
        return nil
    #endif
    }

    /// Doximity icon asset from the `CallWithDoxDialer.bundle` for manual integration
    var iconFromBundle: UIImage? {
        let libraryBundle = Bundle.main
        guard let assetsBundleURL = libraryBundle.url(forResource: "DoximityDialerSDK", withExtension: "bundle") else {
            return nil
        }
        let assetsBundle = Bundle(url: assetsBundleURL)
        let doximityIcon = UIImage(named: "icon", in: assetsBundle, with: nil)

        return doximityIcon
    }

    /// Checks if the Doximity app is installed on the device.
    var isDoximityInstalled: Bool {
        guard let doximitySchemeURL = URL(string: Constants.doximityScheme) else {
            return false
        }
        return application.canOpenURL(doximitySchemeURL)
    }

    /// URL for the Doximity app in the App Store, including app-specific parameters for tracking.
    var doximityAppStoreURL: URL? {
        let appName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown"
        let appIdentifyingName = appName.replacingOccurrences(of: " ", with: "-")
        return URL(string: "https://app.appsflyer.com/\(Constants.appsFlyerID)?pid=third_party_app&c=\(appIdentifyingName)")
    }

    /// Opens a given URL using the provided `UIApplication`.
    func openURL(_ url: URL?) {
        guard let url else { return }
        application.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: Objective-C Bridging

/// Objective-C compatible class for `DoximityDialer`. Used for bridging with Objective-C codebases.
@objc(DoximityDialer)
public final class DoximityDialerObjc: NSObject {
    /// Dials a phone number using Doximity Dialer.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer with the specified phone number and options.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameters:
    ///   - phoneNumber: The phone number to dial (e.g., "5551234567")
    @objc public static func dialPhoneNumber(_ phoneNumber: String) {
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    /// Returns the Doximity icon image.
    ///
    /// - Returns: The Doximity icon as a `UIImage`.
    /// - Throws: `DoximityDialerError.imageAssetNotFound` if the icon cannot be loaded from the SDK resources.
    @objc public static func doximityIcon() throws -> UIImage {
        try DoximityDialer.shared.doximityIcon()
    }

    /// Returns the Doximity icon image as a template for UI customization.
    ///
    /// The returned image uses `.alwaysTemplate` rendering mode, allowing you to tint it with your app's colors.
    ///
    /// - Returns: The Doximity icon as a template `UIImage`.
    /// - Throws: `DoximityDialerError.imageAssetNotFound` if the icon cannot be loaded from the SDK resources.
    @objc public static func doximityIconAsTemplate() throws -> UIImage {
        try DoximityDialer.shared.doximityIconAsTemplate()
    }
}

// MARK: OpenApplicationURL protocol
protocol OpenApplicationURL {
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    )

    nonisolated func canOpenURL(_ url: URL) -> Bool
}

extension UIApplication: OpenApplicationURL { }
