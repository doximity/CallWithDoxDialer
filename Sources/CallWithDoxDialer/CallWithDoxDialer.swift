import Foundation
#if canImport(UIKit)
import UIKit

class DoxDialerCaller: NSObject {
    static let shared = DoxDialerCaller()

    private enum Constants {
        static let doximityScheme = "doximity://"
        static let dialerTargetNumberPath = "dialer/target_number="
        static let appsFlyerID = "id393642611"
    }

    func dialPhoneNumber(_ phoneNumber: String) {
        if isDoximityInstalled {
            openURL(URL(string: "\(Constants.doximityScheme)\(Constants.dialerTargetNumberPath)\(phoneNumber)")!)
        } else {
            guard let url = doximityAppStoreURL else { return }
            openURL(url)
        }
    }

    var doximityIcon: UIImage {
        let bundle = Bundle(for: DoxDialerCaller.self)
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

    var doximityIconAsTemplate: UIImage {
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

#endif
