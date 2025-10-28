<p align="center">
	<a href="https://github.com/doximity/CallWithDoxDialer/"><img src="ReadmeResources/logo.png" width="200" alt="CallWithDoxDialer" /></a><br /><br />
	A µLibrary for making calls using <a href="https://www.doximity.com">Doximity</a>.<br /><br />
</p>
<br />

[![GitHub release](https://img.shields.io/github/release/doximity/CallWithDoxDialer.svg)](https://github.com/doximity/CallWithDoxDialer/releases) ![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg) [![CircleCI](https://dl.circleci.com/status-badge/img/gh/doximity/CallWithDoxDialer/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/doximity/CallWithDoxDialer/tree/master)


## What is DoximityDialerSDK?

Doximity lets healthcare professionals make phone calls to patients while on the go -- without revealing personal phone numbers. Calls are routed through Doximity's HIPAA-secure platform and relayed to the patient who will see the doctor's office number in the Caller ID. Doximity is currently available to verified physicians, nurse practitioners, physician assistants and pharmacists in the United States.

This µLibrary lets 3rd-party apps easily initiate calls through the Doximity app.

**Requirements:** iOS 15.0+

## ⚠️ Required Configuration

**Before using this SDK, you MUST configure your app's Info.plist:**

Add `doximity` to your `LSApplicationQueriesSchemes` array, or the SDK will not work correctly.

<img src="ReadmeResources/InfoPlistExample.png" height="100"/>

In your app's `Info.plist`, add a new entry with key `LSApplicationQueriesSchemes` (or `Queried URL Schemes`) and value type `Array` if one does not already exist. Then add an element to the array of type `String` and value `doximity`.

**Without this configuration:**
- `isDoximityInstalled` will always return `false`
- Users will always be redirected to the App Store, even if Doximity is installed
- Calls will not work

## Integrating DoximityDialerSDK Into Your App

### Swift Package Manager (SPM)

DoximityDialerSDK is distributed via Swift Package Manager. To use this library in your project, add the https://github.com/doximity/CallWithDoxDialer.git repository as a Swift Package.

### Manually
To integrate `DoximityDialerSDK` without a package manager, download the following files and place them anywhere in your project:
- `Sources/DoximityDialerSDK/DoximityDialer.swift`
- `Sources/DoximityDialerSDK/DoximityDialerSDK.bundle`

## Usage

All methods accept phone numbers in various formats:
- Numbers only: `6502333444`
- Formatted: `(650)233-3444`

### Core Functionality
To initiate a call using Doximity, simply call the `dialPhoneNumber` method on the shared `DoximityDialer` instance.
If the Doximity app is not installed, this call will direct the user to Doximity on the App Store.

#### Swift
```swift
import DoximityDialerSDK

...

DoximityDialer.shared.dialPhoneNumber("4254443333")
```

#### Objective-C
```objc
@import DoximityDialerSDK;

...

[DoximityDialer dialPhoneNumber:@"4254443333"];
```

### Auto-Starting Calls
You can automatically start a voice or video call instead of prefilling the number:

#### Swift
```swift
// Start a voice call immediately
DoximityDialer.shared.startVoiceCall("4254443333")

// Start a video call immediately
DoximityDialer.shared.startVideoCall("4254443333")
```

#### Objective-C
```objc
// Start a voice call immediately
[DoximityDialer startVoiceCall:@"4254443333"];

// Start a video call immediately
[DoximityDialer startVideoCall:@"4254443333"];
```

### Checking Installation Status
You can check if the Doximity app is installed to conditionally show/hide UI elements:

#### Swift
```swift
if DoximityDialer.shared.isDoximityInstalled {
    // Show "Call with Doximity" button
} else {
    // Hide button or show "Install Doximity" prompt
}
```

#### Objective-C
```objc
if ([DoximityDialer isDoximityInstalled]) {
    // Show "Call with Doximity" button
} else {
    // Hide button or show "Install Doximity" prompt
}
```

### Icons
The library includes the Doximity icon for use in buttons. These methods throw errors if the icon cannot be loaded, so use try/catch:

#### Swift
```swift
do {
    let icon = try DoximityDialer.shared.doximityIcon()
    // Or for tinted views:
    let templateIcon = try DoximityDialer.shared.doximityIconAsTemplate()
} catch {
    print("Failed to load Doximity icon: \(error)")
}
```

#### Objective-C
```objc
NSError *error = nil;
UIImage *icon = [DoximityDialer doximityIcon:&error];
if (error) {
    NSLog(@"Failed to load Doximity icon: %@", error);
}

// Or for tinted views:
UIImage *templateIcon = [DoximityDialer doximityIconAsTemplate:&error];
```

## Other Platforms

* [Android](https://github.com/doximity/android-dialer-call-lib)

## Have a question?
If you need any help, please reach out! <dialer@doximity.com>.


[Dialer]: https://www.doximity.com/clinicians/download/dialer
