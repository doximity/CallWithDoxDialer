# Doximity Dialer SDK Example

A complete iOS example app demonstrating DoximityDialerSDK integration in **SwiftUI**, **UIKit (Swift)**, and **UIKit (Objective-C)**.

## Features

This unified example app includes:

- **Main Menu** - Choose between SwiftUI, UIKit (Swift), or UIKit (Objective-C) examples
- **SwiftUI Example** - Modern declarative UI implementation
- **UIKit (Swift) Example** - Complete implementation in UIKit with Swift
- **UIKit (Objective-C) Example** - Complete implementation in UIKit with Objective-C
- **Swift/ObjC Interoperability** - Demonstrates mixing both languages in one project

### SDK Features Demonstrated

- ✅ Installation status checking
- ✅ Prefill mode (let user choose call type)
- ✅ Auto-start voice calls
- ✅ Auto-start video calls
- ✅ Icon loading and display
- ✅ Proper Info.plist configuration

## Running the Example

1. Open `DoximityDialerExample.xcodeproj` in Xcode
2. Select a simulator or device
3. Build and run (⌘R)
4. Choose "SwiftUI Example", "UIKit (Swift) Example", or "UIKit (Objective-C) Example" from the main menu

The project uses a local package reference so it will always use the latest version from your local checkout.

## Project Structure

```
DoximityDialerExample/
├── AppDelegate.swift
├── SceneDelegate.swift
├── MainMenuViewController.swift          # Main menu (UIKit)
├── SwiftUIExampleView.swift              # SwiftUI implementation
├── SwiftExampleViewController.swift      # UIKit Swift implementation
├── ObjCExampleViewController.h/m         # UIKit Objective-C implementation
├── DoximityDialerExample-Bridging-Header.h
├── Info.plist                            # With LSApplicationQueriesSchemes & UILaunchScreen
└── Assets.xcassets/
```

## Info.plist Configuration

⚠️ **Critical**: The `Info.plist` includes the required `LSApplicationQueriesSchemes` configuration:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>doximity</string>
</array>
```

Without this, `isDoximityInstalled` will always return `false`.

## Swift/Objective-C Interop

This project demonstrates how to mix SwiftUI, UIKit (Swift), and UIKit (Objective-C) in a single app:

- SwiftUI views can use UIHostingController to integrate with UIKit navigation
- Swift files can import Objective-C headers via the bridging header
- Objective-C files can import Swift-generated headers with `@import`
- The main menu (UIKit) navigates to SwiftUI, Swift, and Objective-C view controllers

This is valuable for vendors integrating the SDK into existing apps with mixed UI frameworks and languages.

## Troubleshooting

### "Missing package product 'DoximityDialerSDK'" Error

If you see this error when opening the project:

1. **File → Add Package Dependencies...**
2. Click **"Add Local..."**
3. Navigate to and select the `CallWithDoxDialer` root directory
4. Click **"Add Package"**

### Build Errors

If you encounter build errors:

- Clean the build folder: **Product → Clean Build Folder** (⇧⌘K)
- Delete DerivedData
- Restart Xcode

## Next Steps

1. Run the app and explore both examples
2. Review the source code to understand the integration patterns
3. Copy the relevant patterns into your own app
4. Don't forget to configure your Info.plist!
