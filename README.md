<p align="center">
	<a href="https://github.com/doximity/CallWithDoxDialer/"><img src="ReadmeResources/logo.png" width="200" alt="CallWithDoxDialer" /></a><br /><br />
	A µLibrary for making calls using <a href="https://www.doximity.com">Doximity</a>.<br /><br />
</p>
<br />

[![GitHub release](https://img.shields.io/github/release/doximity/CallWithDoxDialer.svg)](https://github.com/doximity/CallWithDoxDialer/releases) ![platforms](https://img.shields.io/badge/platforms-iOS-lightgrey.svg)


## What is CallWithDoxDialer?

Doximity lets healthcare professionals make phone calls to patients while on the go -- without revealing personal phone numbers. Calls are routed through Doximity's HIPAA-secure platform and relayed to the patient who will see the doctor's office number in the Caller ID. Doximity is currently available to verified physicians, nurse practitioners, physician assistants and pharmacists in the United States.

This µLibrary lets 3rd-party apps easily initiate calls through the Doximity app.

## Other Platforms

* [Android](https://github.com/doximity/android-dialer-call-lib)

## Usage

### Core Functionality
To initiate a call using Doximity, simply call the `dialPhoneNumber` method on the shared `DoxDialerCaller` instance.
If the Doximity app is not installed, this call will direct the user to Doximity on the App Store.

Most reasonable phone number formats are accepted by the `dialPhoneNumber` method, e.g.:
- using numbers only: `6502333444`
- formatted: `(650)233-3444`
- with a leading international area code: `+1(650)233-3444`

#### Using Swift
```
import CallWithDoxDialer

...

DoxDialerCaller.shared.dialPhoneNumber("4254443333")
```

#### Using Objective-C
```
@import CallWithDoxDialer

...

[DoxDialerCaller dialPhoneNumber:@"4254443333"];
```

### Icons
The library also includes a version of the Doximity icon appropriate for use inside buttons.
It's available through
- `DoxDialerCaller.shared.dialerIcon`
- `DoxDialerCaller.shared.dialerIconAsTemplate` (for use in tinted views)



## Integrating CallWithDoxDialer Into Your App

CallWithDoxDialer supports iOS 15.0+.

First, you must give your app permission to open the Doximity app.

<img src="ReadmeResources/InfoPlistExample.png" height="100"/>

In your app's `Info.plist`, add a new entry with key `LSApplicationQueriesSchemes` (or `Queried URL Schemes`) and value type `Array` if one does not already exist.
Then add an element to the array of type `String` and value `doximity`.


#### Swift Package Manager (SPM)

CallWithDoxDialer is now distributed via Swift Package Manager. To use this library in your project, add the https://github.com/doximity/CallWithDoxDialer.git repository as a Swift Pacakge.


#### Manually
To integrate `CallWithDoxDialer` without a package manager, simply download the following files, and place it anywhere in your project:
- `Sources/CallWithDoxDialer/CallWithDoxDialer.swift`
- `Sources/CallWithDoxDialer/CallWithDoxDialer.bundle`


## Have a question?
If you need any help, please reach out! <dialer@doximity.com>.


[Dialer]: https://www.doximity.com/clinicians/download/dialer
