import Foundation
import Testing
@testable import DoximityDialerSDK

@Suite(.serialized)
class `Doximity Dialer Tests` {
    let application = MockApplication()

    init() {
        DoximityDialer.setSharedInstance(DoximityDialer(application: application))
    }

    class `Core Functionality`: `Doximity Dialer Tests` {
        @Test
        func `Dials with prefill option when Doximity is installed`() {
            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Starts a voice call`() {
            DoximityDialer.shared.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Starts a video call`() {
            DoximityDialer.shared.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Redirects to App Store when Doximity is not installed`() {
            application.canOpenURL = false

            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "https://app.appsflyer.com/id393642611?pid=third_party_app&c=Unknown"))
        }

        @Test
        func `URL encodes special characters in phone number`() {
            DoximityDialer.shared.dialPhoneNumber("+1 (555) 123-4567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=+1%20(555)%20123-4567&utm_source=com.apple.dt.xctest.tool"))
        }
    }

    class `Installation Check`: `Doximity Dialer Tests` {
        @Test
        func `Returns true when Doximity is installed`() {
            application.canOpenURL = true
            #expect(DoximityDialer.shared.isDoximityInstalled == true)
        }

        @Test
        func `Returns false when Doximity is not installed`() {
            application.canOpenURL = false
            #expect(DoximityDialer.shared.isDoximityInstalled == false)
        }
    }

    class `Objective C Bridge`: `Doximity Dialer Tests` {
        @Test
        func `Dials with prefill`() {
            DoximityDialerObjc.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Starts voice call`() {
            DoximityDialerObjc.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Starts video call`() {
            DoximityDialerObjc.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func `Returns icon`() throws {
            _ = try DoximityDialerObjc.doximityIcon()
        }

        @Test
        func `Returns icon as template`() throws {
            let image = try DoximityDialerObjc.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }

        @Test
        func `Checks if Doximity is installed`() {
            application.canOpenURL = true
            #expect(DoximityDialerObjc.isDoximityInstalled() == true)
        }

        @Test
        func `Checks if Doximity is not installed`() {
            application.canOpenURL = false
            #expect(DoximityDialerObjc.isDoximityInstalled() == false)
        }
    }

    class Icon: `Doximity Dialer Tests` {
        @Test
        func `Returns Doximity icon image`() throws {
            _ = try DoximityDialer.shared.doximityIcon()
        }

        @Test
        func `Returns Doximity icon as template`() throws {
            let image = try DoximityDialer.shared.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }
    }

    class Options: `Doximity Dialer Tests` {
        @Test
        func `Prefill path is correct`() {
            let options = DoximityDialer.Options.prefill
            #expect(options.path == "dialer/call")
        }

        @Test
        func `Start voice call path is correct`() {
            let options = DoximityDialer.Options.startCall(.voice)
            #expect(options.path == "dialer/call/voice")
        }

        @Test
        func `Start video call path is correct`() {
            let options = DoximityDialer.Options.startCall(.video)
            #expect(options.path == "dialer/call/video")
        }
    }
}
