import Foundation
import UIKit

public protocol OpenApplicationURL {
    func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey: Any], completionHandler completion: ((Bool) -> Void)?)
    func canOpenURL(_ url: URL) -> Bool
}

extension UIApplication: OpenApplicationURL { }
