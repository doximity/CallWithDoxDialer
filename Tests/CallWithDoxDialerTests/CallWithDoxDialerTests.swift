import XCTest
@testable import CallWithDoxDialer

final class CallWithDoxDialerTests: XCTestCase {

    var dialerCaller: DoxDialerCaller!
    var mockApplication: MockApplication!

    override func setUp() {
        super.setUp()
        mockApplication = MockApplication()
        dialerCaller = DoxDialerCaller(application: mockApplication)
    }

    override func tearDown() {
        dialerCaller = nil
        mockApplication = nil
        super.tearDown()
    }

    func testDialPhoneNumber_WithDoximityNotInstalled_ShouldOpenAppStoreURL() {
        dialerCaller.dialPhoneNumber("1234567890")
        XCTAssertEqual(mockApplication.lastURL, URL(string: "doximity://dialer/call?target_number=1234567890"))
    }

    func testDialPhoneNumber_WithDoximityInstalled_ShouldOpenCorrectURL() {
        mockApplication.canOpenURL = false
        dialerCaller.dialPhoneNumber("1234567890")
        XCTAssertEqual(mockApplication.lastURL, URL(string: "https://app.appsflyer.com/id393642611?pid=third_party_app&c=Unknown"))
    }

    func testDoximityIcon_ShouldReturnImage() {
        let image = dialerCaller.doximityIcon
        XCTAssertNotNil(image)
    }
}
