import Foundation
#if canImport(UIKit)
import UIKit

public struct DoxDialerCaller {
    public static let shared = DoxDialerCaller()

    private enum Constants {
        static let doximityScheme = "doximity://"
        static let dialerTargetNumberPath = "dialer/call?target_number="
        static let appsFlyerID = "id393642611"
    }

    public func dialPhoneNumber(_ phoneNumber: String) {
        if isDoximityInstalled {
            guard let dialerURL = URL(string: "\(Constants.doximityScheme)\(Constants.dialerTargetNumberPath)\(phoneNumber)") else { return }
            openURL(dialerURL)
        } else {
            guard let url = doximityAppStoreURL else { return }
            openURL(url)
        }
    }

    public var doximityIcon: UIImage {
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
    }

    public var doximityIconAsTemplate: UIImage {
        doximityIcon.withRenderingMode(.alwaysTemplate)
    }
}

private extension DoxDialerCaller {
    var isDoximityInstalled: Bool {
        guard let doximitySchemeURL = URL(string: Constants.doximityScheme) else {
            return false
        }
        return UIApplication.shared.canOpenURL(doximitySchemeURL)
    }

    var doximityAppStoreURL: URL? {
        let appName: String = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? "Unknown"
        let appIdentifyingName = appName.replacingOccurrences(of: " ", with: "-")
        return URL(string: "https://app.appsflyer.com/\(Constants.appsFlyerID)?pid=third_party_app&c=\(appIdentifyingName)")
    }

    func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: Objective-C Bridging
@objc(DoxDialerCaller)
public final class DoxDialerCallerObjc: NSObject {
    @objc public static func dialPhoneNumber(_ phoneNumber: String) {
        DoxDialerCaller.shared.dialPhoneNumber(phoneNumber)
    }

    @objc public static var doximityIcon: UIImage {
        DoxDialerCaller.shared.doximityIcon
    }

    @objc public static var doximityIconAsTemplate: UIImage {
        DoxDialerCaller.shared.doximityIconAsTemplate
    }
}


#endif
