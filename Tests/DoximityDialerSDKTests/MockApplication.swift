import Foundation
@testable import DoximityDialerSDK
import UIKit

final class MockApplication: OpenApplicationURL {
    var lastURL: URL?
    var canOpenURL = true

    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completionHandler completion: (@MainActor @Sendable (Bool) -> Void)?
    ) {
        lastURL = url
    }

    nonisolated func canOpenURL(_ url: URL) -> Bool {
        canOpenURL
    }
}
