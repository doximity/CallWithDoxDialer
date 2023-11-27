import Foundation
@testable import CallWithDoxDialer
import UIKit

final class MockApplication: OpenApplicationURL {
    var lastURL: URL?
    var canOpenURL = true

    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil) {
        lastURL = url
    }

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURL
    }
}
