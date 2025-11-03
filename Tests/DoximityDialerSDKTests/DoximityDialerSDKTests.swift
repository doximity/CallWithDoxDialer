import Foundation
import Testing
@testable import DoximityDialerSDK

@Suite(.serialized)
class DoximityDialerTests {
    let application = MockApplication()

    init() {
        DoximityDialer.setSharedInstance(DoximityDialer(application: application))
    }

    class CoreFunctionality: DoximityDialerTests {
        @Test
        func testDialsWithPrefill() {
            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testStartsVoiceCall() {
            DoximityDialer.shared.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testStartsVideoCall() {
            DoximityDialer.shared.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testRedirectsWhenNotInstalled() {
            application.canOpenURL = false

            DoximityDialer.shared.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "https://doximity.sng.link/Az2j3/c17w?_dl=https://www.doximity.com/dialer/home&_smtype=3&pid=third_party_app&c=Unknown"))
        }

        @Test
        func testEncodesSpecialCharacters() {
            DoximityDialer.shared.dialPhoneNumber("+1 (555) 123-4567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=+1%20(555)%20123-4567&utm_source=com.apple.dt.xctest.tool"))
        }
    }

    class InstallationCheck: DoximityDialerTests {
        @Test
        func testReturnsTrueWhenInstalled() {
            application.canOpenURL = true
            #expect(DoximityDialer.shared.isDoximityInstalled == true)
        }

        @Test
        func testReturnsFalseWhenNotInstalled() {
            application.canOpenURL = false
            #expect(DoximityDialer.shared.isDoximityInstalled == false)
        }
    }

    class Icon: DoximityDialerTests {
        @Test
        func testReturnsIcon() throws {
            _ = try DoximityDialer.shared.doximityIcon()
        }

        @Test
        func testReturnsIconAsTemplate() throws {
            let image = try DoximityDialer.shared.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }
    }

    class Options: DoximityDialerTests {
        @Test
        func testPrefillPath() {
            let options = DoximityDialer.Options.prefill
            #expect(options.path == "dialer/call")
        }

        @Test
        func testVoiceCallPath() {
            let options = DoximityDialer.Options.startCall(.voice)
            #expect(options.path == "dialer/call/voice")
        }

        @Test
        func testVideoCallPath() {
            let options = DoximityDialer.Options.startCall(.video)
            #expect(options.path == "dialer/call/video")
        }
    }

    class ObjectiveCBridge: DoximityDialerTests {
        @Test
        func testDialsWithPrefill() {
            DoximityDialerObjc.dialPhoneNumber("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testStartsVoiceCall() {
            DoximityDialerObjc.startVoiceCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testStartsVideoCall() {
            DoximityDialerObjc.startVideoCall("5551234567")
            #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
        }

        @Test
        func testReturnsTrueWhenInstalled() {
            application.canOpenURL = true
            #expect(DoximityDialerObjc.isDoximityInstalled() == true)
        }

        @Test
        func testReturnsFalseWhenNotInstalled() {
            application.canOpenURL = false
            #expect(DoximityDialerObjc.isDoximityInstalled() == false)
        }

        @Test
        func testReturnsIcon() throws {
            _ = try DoximityDialerObjc.doximityIcon()
        }

        @Test
        func testReturnsIconAsTemplate() throws {
            let image = try DoximityDialerObjc.doximityIconAsTemplate()
            #expect(image.renderingMode == .alwaysTemplate)
        }
    }
}
