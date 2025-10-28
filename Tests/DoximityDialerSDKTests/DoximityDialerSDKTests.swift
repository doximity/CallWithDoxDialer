import Foundation
import Testing
@testable import DoximityDialerSDK

@Suite("DoximityDialer Tests", .serialized)
class DoximityDialerSDKTests {
    let application = MockApplication()

    init() {
        DoximityDialer.setSharedInstance(DoximityDialer(application: application))
    }

    class CoreFunctionality: DoximityDialerSDKTests {
        @Test("Dials with prefill option when Doximity is installed")
        func dialPhoneNumberWithPrefill() {
            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Starts a voice call")
        func startVoiceCall() {
            DoximityDialer.shared.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Starts a video call")
        func startVideoCall() {
            DoximityDialer.shared.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Redirects to App Store when Doximity is not installed")
        func dialPhoneNumberWhenNotInstalled() {
            application.canOpenURL = false

            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "https://app.appsflyer.com/id393642611?pid=third_party_app&c=Unknown"))
        }

        @Test("URL encodes special characters in phone number")
        func dialPhoneNumberWithSpecialCharacters() {
            DoximityDialer.shared.dialPhoneNumber("+1 (555) 123-4567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=+1%20(555)%20123-4567&utm_source=com.apple.dt.xctest.tool"))
        }
    }

    class ObjCBridge: DoximityDialerSDKTests {
        @Test("Dials with prefill")
        func dialPhoneNumber() {
            DoximityDialerObjc.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Starts voice call")
        func startVoiceCall() {
            DoximityDialerObjc.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Starts video call")
        func startVideoCall() {
            DoximityDialerObjc.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test("Returns icon")
        func doximityIcon() throws {
            _ = try DoximityDialerObjc.doximityIcon()
        }

        @Test("Returns icon as template")
        func doximityIconAsTemplate() throws {
            let image = try DoximityDialerObjc.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }
    }

    class Icon: DoximityDialerSDKTests {
        @Test("Returns Doximity icon image")
        func doximityIcon() throws {
            _ = try DoximityDialer.shared.doximityIcon()
        }

        @Test("Returns Doximity icon as template")
        func doximityIconAsTemplate() throws {
            let image = try DoximityDialer.shared.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }
    }

    class Options: DoximityDialerSDKTests {
        @Test("Prefill path is correct")
        func prefillPath() {
            let options = DoximityDialer.Options.prefill
            #expect(options.path == "dialer/call")
        }

        @Test("Start voice call path is correct")
        func startVoiceCallPath() {
            let options = DoximityDialer.Options.startCall(.voice)
            #expect(options.path == "dialer/call/voice")
        }

        @Test("Start video call path is correct")
        func startVideoCallPath() {
            let options = DoximityDialer.Options.startCall(.video)
            #expect(options.path == "dialer/call/video")
        }
    }
}
