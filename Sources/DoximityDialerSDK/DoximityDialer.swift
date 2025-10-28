import Foundation
import UIKit

/// A struct to handle dialing phone numbers using the Doximity app.
public struct DoximityDialer {
    /// Singleton instance of `DoximityDialer`.
    public private(set) static var shared = DoximityDialer()

    #if DEBUG
    /// Replaces the shared instance with a custom instance for testing. Only available in DEBUG builds.
    /// - Parameter instance: The test instance to use, or nil to reset to default
    static func setSharedInstance(_ instance: DoximityDialer?) {
        shared = instance ?? DoximityDialer()
    }
    #endif

    /// Errors that can occur when using `DoximityDialer`.
    public enum DoximityDialerError: Error {
        /// The Doximity icon image asset could not be found in the SDK bundle or package resources.
        case imageAssetNotFound
    }

    private enum Constants {
        static let doximityName = "doximity"
        static let doximityScheme = "\(doximityName)://"
        static let appsFlyerID = "id393642611"
        static let bundleID = Bundle.main.bundleIdentifier ?? "com.doximity.dialersdk"
        static let basePath = "dialer/call"
        static let queryItemSourceKey = "utm_source"
        static let queryItemTargetNumberKey = "target_number"
    }

    private let application: OpenApplicationURL

    /// Options for how Doximity Dialer should handle the phone number.
    enum Options: Equatable {
        /// The type of call to initiate.
        enum Kind: String, Equatable {
            case voice
            case video
        }

        /// Prefills the phone number in Doximity Dialer without automatically starting the call.
        case prefill

        /// Automatically starts a call in Doximity Dialer of the specified `Kind`.
        case startCall(Kind)

        var path: String {
            switch self {
            case .prefill: Constants.basePath
            case let .startCall(kind): "\(Constants.basePath)/\(kind.rawValue)"
            }
        }
    }

    init(application: OpenApplicationURL = UIApplication.shared) {
        self.application = application
    }

    /// Prefills a phone number into Doximity Dialer, allowing the user to select the type of call.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer with the specified phone number in prefill mode.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to dial (e.g., "5551234567")
    public func dialPhoneNumber(_ phoneNumber: String) {
        dial(phoneNumber, options: .prefill)
    }

    /// Automatically starts a voice call in Doximity Dialer with the specified phone number.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer and automatically initiates a voice call.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to call (e.g., "5551234567")
    public func startVoiceCall(_ phoneNumber: String) {
        dial(phoneNumber, options: .startCall(.voice))
    }

    /// Automatically starts a video call in Doximity Dialer with the specified phone number.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer and automatically initiates a video call.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to call (e.g., "5551234567")
    public func startVideoCall(_ phoneNumber: String) {
        dial(phoneNumber, options: .startCall(.video))
    }

    /// Shared implementation for dialing phone numbers through Doximity Dialer.
    ///
    /// Constructs the appropriate deep link URL based on the provided options and opens it.
    /// If Doximity is not installed, redirects to the App Store instead.
    ///
    /// - Parameters:
    ///   - phoneNumber: The phone number to dial
    ///   - options: The dialing behavior (prefill or auto-start voice/video call)
    private func dial(_ phoneNumber: String, options: Options) {
        guard isDoximityInstalled else {
            openURL(doximityAppStoreURL)
            return
        }

        var components = URLComponents(string: Constants.doximityScheme + options.path)
        components?.queryItems = [
            URLQueryItem(name: Constants.queryItemTargetNumberKey, value: phoneNumber),
            URLQueryItem(name: Constants.queryItemSourceKey, value: Constants.bundleID),
        ]

        openURL(components?.url)
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
    /// Prefills a phone number into Doximity Dialer, allowing the user to select the type of call.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer with the specified phone number in prefill mode.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to dial (e.g., "5551234567")
    @objc public static func dialPhoneNumber(_ phoneNumber: String) {
        DoximityDialer.shared.dialPhoneNumber(phoneNumber)
    }

    /// Automatically starts a voice call in Doximity Dialer with the specified phone number.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer and automatically initiates a voice call.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to call (e.g., "5551234567")
    @objc public static func startVoiceCall(_ phoneNumber: String) {
        DoximityDialer.shared.startVoiceCall(phoneNumber)
    }

    /// Automatically starts a video call in Doximity Dialer with the specified phone number.
    ///
    /// If the Doximity app is installed, opens Doximity Dialer and automatically initiates a video call.
    /// If the Doximity app is not installed, redirects the user to the App Store to download Doximity.
    ///
    /// - Parameter phoneNumber: The phone number to call (e.g., "5551234567")
    @objc public static func startVideoCall(_ phoneNumber: String) {
        DoximityDialer.shared.startVideoCall(phoneNumber)
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
