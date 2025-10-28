import Foundation
import Testing
@testable import DoximityDialerSDK

@Suite("DoximityDialer Tests", .serialized)
struct DoximityDialerSDKTests {
    var application = MockApplication()

    init() {
        DoximityDialer.setSharedInstance(DoximityDialer(application: application))
    }

    // MARK: - dialPhoneNumber Tests

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

    // MARK: - Objective-C Bridge Tests

    @Test("Objective-C bridge dials with prefill")
    func objcBridgePrefill() {
        DoximityDialerObjc.dialPhoneNumber("5551234567")
        #expect(application.lastURL == URL(string: "doximity://dialer/call?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    @Test("Objective-C bridge starts voice call")
    func objcBridgeStartVoiceCall() {
        DoximityDialerObjc.startVoiceCall("5551234567")
        #expect(application.lastURL == URL(string: "doximity://dialer/call/voice?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    @Test("Objective-C bridge starts video call")
    func objcBridgeStartVideoCall() {
        DoximityDialerObjc.startVideoCall("5551234567")
        #expect(application.lastURL == URL(string: "doximity://dialer/call/video?target_number=5551234567&utm_source=com.apple.dt.xctest.tool"))
    }

    // MARK: - Icon Tests

    @Test("Returns Doximity icon image")
    func doximityIcon() throws {
        _ = try DoximityDialer.shared.doximityIcon()
    }

    @Test("Returns Doximity icon as template")
    func doximityIconAsTemplate() throws {
        let image = try DoximityDialer.shared.doximityIconAsTemplate()
        #expect(image.renderingMode == .alwaysTemplate)
    }

    @Test("Objective-C bridge returns icon")
    func objcBridgeIcon() throws {
        _ = try DoximityDialerObjc.doximityIcon()
    }

    @Test("Objective-C bridge returns icon as template")
    func objcBridgeIconAsTemplate() throws {
        let image = try DoximityDialerObjc.doximityIconAsTemplate()
        #expect(image.renderingMode == .alwaysTemplate)
    }
}
