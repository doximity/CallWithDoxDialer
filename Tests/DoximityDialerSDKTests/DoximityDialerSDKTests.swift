import Foundation
import Testing
@testable import DoximityDialerSDK

@Suite("DoximityDialer Tests")
struct DoximityDialerSDKTests {

    // MARK: - dialPhoneNumber Tests

    @Test("Dials with prefill option when Doximity is installed")
    func dialPhoneNumberWithPrefill() {
        let mockApplication = MockApplication()
        mockApplication.canOpenURL = true
        let dialerCaller = DoximityDialer(application: mockApplication)

        dialerCaller.dialPhoneNumber("5551234567")

        #expect(mockApplication.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    @Test("Starts a voice call")
    func startVoiceCall() {
        let mockApplication = MockApplication()
        mockApplication.canOpenURL = true
        let dialerCaller = DoximityDialer(application: mockApplication)

        dialerCaller.startVoiceCall("5551234567")

        #expect(mockApplication.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    @Test("Starts a video call")
    func startVideoCall() {
        let mockApplication = MockApplication()
        mockApplication.canOpenURL = true
        let dialerCaller = DoximityDialer(application: mockApplication)

        dialerCaller.startVideoCall("5551234567")

        #expect(mockApplication.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    @Test("Redirects to App Store when Doximity is not installed")
    func dialPhoneNumberWhenNotInstalled() {
        let mockApplication = MockApplication()
        mockApplication.canOpenURL = false
        let dialerCaller = DoximityDialer(application: mockApplication)

        dialerCaller.dialPhoneNumber("5551234567")

        #expect(mockApplication.lastURL == URL(string: "https://app.appsflyer.com/id393642611?pid=third_party_app&c=Unknown"))
    }

    @Test("URL encodes special characters in phone number")
    func dialPhoneNumberWithSpecialCharacters() {
        let mockApplication = MockApplication()
        mockApplication.canOpenURL = true
        let dialerCaller = DoximityDialer(application: mockApplication)

        dialerCaller.dialPhoneNumber("+1 (555) 123-4567")

        #expect(mockApplication.lastURL == URL(string: "doximity://dialer/call?target_number=+1%20(555)%20123-4567&utm_source=com.apple.dt.xctest.tool"))
    }

    // MARK: - Options Tests

    @Test("Options prefill path is correct")
    func optionsPrefillPath() {
        let options = DoximityDialer.Options.prefill
        #expect(options.path == "dialer/call")
    }

    @Test("Options start voice call path is correct")
    func optionsStartVoiceCallPath() {
        let options = DoximityDialer.Options.startCall(.voice)
        #expect(options.path == "dialer/call/voice")
    }

    @Test("Options start video call path is correct")
    func optionsStartVideoCallPath() {
        let options = DoximityDialer.Options.startCall(.video)
        #expect(options.path == "dialer/call/video")
    }

    @Test("Options are equatable")
    func optionsEquatable() {
        #expect(DoximityDialer.Options.prefill == DoximityDialer.Options.prefill)
        #expect(DoximityDialer.Options.startCall(.voice) == DoximityDialer.Options.startCall(.voice))
        #expect(DoximityDialer.Options.startCall(.video) == DoximityDialer.Options.startCall(.video))
        #expect(DoximityDialer.Options.prefill != DoximityDialer.Options.startCall(.voice))
        #expect(DoximityDialer.Options.startCall(.voice) != DoximityDialer.Options.startCall(.video))
    }

    // MARK: - Icon Tests

    @Test("Returns Doximity icon image")
    func doximityIcon() throws {
        let mockApplication = MockApplication()
        let dialerCaller = DoximityDialer(application: mockApplication)

        let image = try dialerCaller.doximityIcon()

        #expect(image != nil)
    }

    @Test("Returns Doximity icon as template")
    func doximityIconAsTemplate() throws {
        let mockApplication = MockApplication()
        let dialerCaller = DoximityDialer(application: mockApplication)

        let image = try dialerCaller.doximityIconAsTemplate()

        #expect(image != nil)
        #expect(image.renderingMode == .alwaysTemplate)
    }

    @Test("Objective-C bridge returns icon")
    func objcBridgeIcon() throws {
        let image = try DoximityDialerObjc.doximityIcon()
        #expect(image != nil)
    }

    @Test("Objective-C bridge returns icon as template")
    func objcBridgeIconAsTemplate() throws {
        let image = try DoximityDialerObjc.doximityIconAsTemplate()
        #expect(image != nil)
        #expect(image.renderingMode == .alwaysTemplate)
    }
}
