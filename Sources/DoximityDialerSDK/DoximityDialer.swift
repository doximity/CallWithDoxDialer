import Foundation
import UIKit

/// A struct to handle dialing phone numbers using the Doximity app.
public struct DoximityDialer {
    /// Singleton instance of `DoximityDialer`.
    public static let shared = DoximityDialer()

    public enum DoximityDialerError: Error {
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

    /// Dials a phone number using the Doximity app if it's installed; otherwise,
    /// it directs the user to the App Store page for the Doximity app.
    /// - Parameters:
    ///   - phoneNumber: The 10-digit phone number `String` to dial
    ///   - options: The dialing option (prefill, voice call, or video call). Defaults to `.prefill`
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
    public func doximityIcon() throws -> UIImage {
        guard let image = iconFromPackage ?? iconFromBundle else {
            throw DoximityDialerError.imageAssetNotFound
        }
        return image
    }

    /// Returns the Doximity icon image as a template for UI customization.
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
    @objc public static func dialPhoneNumber(_ phoneNumber: String) {
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    /// Objective-C bridging function that returns the Doximity icon image.
    @objc public static func doximityIcon() throws -> UIImage {
        try DoximityDialer.shared.doximityIcon()
    }

    /// Objective-C bridging function that returns the Doximity
    /// icon image as a template for UI customization.
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
