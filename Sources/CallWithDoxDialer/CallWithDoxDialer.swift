import Foundation
import UIKit

/// A struct to handle dialing phone numbers using the Doximity app.
public struct DoxDialerCaller {
    /// Singleton instance of `DoxDialerCaller`.
    public static let shared = DoxDialerCaller()

    public enum DoximityDialerError: Error {
        case imageAssetNotFound
    }

    /// Constants used in `DoxDialerCaller`.
    private enum Constants {
        static let doximityScheme = "doximity://"
        static let dialerTargetNumberPath = "dialer/call?target_number="
        static let appsFlyerID = "id393642611"
    }

    private let application: OpenApplicationURL

    init(application: OpenApplicationURL = UIApplication.shared) {
        self.application = application
    }

    /// Dials a phone number using the Doximity app if it's installed; otherwise,
    /// it directs the user to the App Store page for the Doximity app.
    /// - Parameter phoneNumber: The 10-digit phone number `String` to dial
    public func dialPhoneNumber(_ phoneNumber: String) {
        if isDoximityInstalled {
            guard let dialerURL = URL(string: "\(Constants.doximityScheme)\(Constants.dialerTargetNumberPath)\(phoneNumber)") else { return }
            openURL(dialerURL)
        } else {
            guard let url = doximityAppStoreURL else { return }
            openURL(url)
        }
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

private extension DoxDialerCaller {
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
        guard let assetsBundleURL = libraryBundle.url(forResource: "CallWithDoxDialer", withExtension: "bundle") else {
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
    func openURL(_ url: URL) {
        application.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: Objective-C Bridging

/// Objective-C compatible class for `DoxDialerCaller`. Used for bridging with Objective-C codebases.
@objc(DoxDialerCaller)
public final class DoxDialerCallerObjc: NSObject {
    @objc public static func dialPhoneNumber(_ phoneNumber: String) {
        DoxDialerCaller.shared.dialPhoneNumber(phoneNumber)
    }

    /// Objective-C bridging function that returns the Doximity icon image.
    @objc public static func doximityIcon() throws -> UIImage {
        try DoxDialerCaller.shared.doximityIcon()
    }

    /// Objective-C bridging function that returns the Doximity
    /// icon image as a template for UI customization.
    @objc public static func doximityIconAsTemplate() throws -> UIImage {
        try DoxDialerCaller.shared.doximityIconAsTemplate()
    }
}
